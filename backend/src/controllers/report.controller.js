const Expense = require("../models/Expense");
const Income = require("../models/Income");

exports.getAnalysis = async (req, res) => {
    try {
        const userId = req.user.id;
        const { period } = req.query;

        let dateQuery = {};
        const now = new Date();

        if (period === "Daily") {
            dateQuery = { $gte: new Date(now.setHours(0, 0, 0, 0)) };
        } else if (period === "Month") {
            dateQuery = { $gte: new Date(now.getFullYear(), now.getMonth(), 1) };
        } else if (period === "Year") {
            dateQuery = { $gte: new Date(now.getFullYear(), 0, 1) };
        }

        const query = { user: userId };
        if (Object.keys(dateQuery).length > 0) {
            query.date = dateQuery;
        }

        const expenses = await Expense.find(query);
        const incomes = await Income.find(query);

        const totalExpense = expenses.reduce((acc, curr) => acc + curr.amount, 0);
        const totalIncome = incomes.reduce((acc, curr) => acc + curr.amount, 0);

        const categoryMap = {};
        expenses.forEach(exp => {
            if (!categoryMap[exp.category]) {
                categoryMap[exp.category] = 0;
            }
            categoryMap[exp.category] += exp.amount;
        });

        const topCategories = Object.keys(categoryMap).map(cat => ({
            name: cat,
            amount: categoryMap[cat],
            percentage: totalExpense > 0 ? (categoryMap[cat] / totalExpense) : 0
        })).sort((a, b) => b.amount - a.amount).slice(0, 5);

        const chartData = expenses.map(e => ({
            date: e.date,
            amount: e.amount
        })).sort((a, b) => new Date(a.date) - new Date(b.date));

        res.status(200).json({
            totalIncome,
            totalExpense,
            balance: totalIncome - totalExpense,
            topCategories,
            chartData
        });

    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};
