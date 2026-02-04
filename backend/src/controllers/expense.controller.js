const Expense = require("../models/Expense");
const Income = require("../models/Income");

// Add Expense
exports.addExpense = async (req, res) => {
    try {
        const { title, amount, category, description, date } = req.body;

        const incomeDocs = await Income.find({ user: req.user.id });
        const totalIncome = incomeDocs.reduce((acc, curr) => acc + curr.amount, 0);

        const expenseDocs = await Expense.find({ user: req.user.id });
        const totalExpenses = expenseDocs.reduce((acc, curr) => acc + curr.amount, 0);

        const availableBalance = totalIncome - totalExpenses;

        if (amount > availableBalance) {
            return res.status(400).json({ message: "Insufficient balance. Please enter an amount less than or equal to your available balance." });
        }

        const expense = new Expense({
            title,
            amount,
            category,
            description,
            date: date || Date.now(),
            user: req.user.id // from auth middleware
        });

        await expense.save();

        res.status(200).json({ message: "Expense added", expense });
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};

// Get Expenses
exports.getExpenses = async (req, res) => {
    try {
        const expenses = await Expense.find({ user: req.user.id })
            .sort({ createdAt: -1 });
        res.status(200).json(expenses);
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};

// Delete Expense
exports.deleteExpense = async (req, res) => {
    try {
        const { id } = req.params;
        const expense = await Expense.findById(id);

        if (!expense) return res.status(404).json({ message: "Expense not found" });

        // Validate ownership
        if (expense.user.toString() !== req.user.id) {
            return res.status(403).json({ message: "Not authorized to delete this expense" });
        }

        await Expense.findByIdAndDelete(id);
        res.status(200).json({ message: "Expense deleted" });
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};
