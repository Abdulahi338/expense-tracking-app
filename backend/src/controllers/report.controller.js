const Income = require("../models/Income");
const Expense = require("../models/Expense");

// helper: build date range
function getRange(type, year, month, day) {
  if (type === "daily") {
    const start = new Date(year, month - 1, day);
    const end = new Date(year, month - 1, day + 1);
    return { start, end };
  }

  if (type === "monthly") {
    const start = new Date(year, month - 1, 1);
    const end = new Date(year, month, 1);
    return { start, end };
  }

  if (type === "yearly") {
    const start = new Date(year, 0, 1);
    const end = new Date(year + 1, 0, 1);
    return { start, end };
  }

  return null;
}

//GET /api/reports/daily?year=2026&month=2&day=1
exports.dailyReport = async (req, res) => {
  try {
    const year = Number(req.query.year);
    const month = Number(req.query.month);
    const day = Number(req.query.day);

    if (!year || !month || !day) {
      return res
        .status(400)
        .json({ message: "year, month, day are required" });
    }

    const range = getRange("daily", year, month, day);

    const incomes = await Income.find({ date: { $gte: range.start, $lt: range.end } });
    const expenses = await Expense.find({ date: { $gte: range.start, $lt: range.end } });

    let totalIncome = 0;
    for (const i of incomes) totalIncome += Number(i.amount);

    let totalExpense = 0;
    for (const e of expenses) totalExpense += Number(e.amount);

    return res.json({
      type: "daily",
      year,
      month,
      day,
      totalIncome,
      totalExpense,
      balance: totalIncome - totalExpense,
      incomeCount: incomes.length,
      expenseCount: expenses.length,
    });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};


// // GET /api/reports/monthly?year=2026&month=2
exports.monthlyReport = async (req, res) => {
  try {
    const year = Number(req.query.year);
    const month = Number(req.query.month);

    if (!year || !month) {
      return res.status(400).json({ message: "year and month are required" });
    }

    const range = getRange("monthly", year, month);

    const incomes = await Income.find({ date: { $gte: range.start, $lt: range.end } });
    const expenses = await Expense.find({ date: { $gte: range.start, $lt: range.end } });

    let totalIncome = 0;
    for (const i of incomes) totalIncome += Number(i.amount);

    let totalExpense = 0;
    for (const e of expenses) totalExpense += Number(e.amount);

    return res.json({
      type: "monthly",
      year,
      month,
      totalIncome,
      totalExpense,
      balance: totalIncome - totalExpense,
      incomeCount: incomes.length,
      expenseCount: expenses.length,
    });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};


// // GET /api/reports/yearly?year=2026
exports.yearlyReport = async (req, res) => {
  try {
    const year = Number(req.query.year);

    if (!year) {
      return res.status(400).json({ message: "year is required" });
    }

    const range = getRange("yearly", year);

    const incomes = await Income.find({ date: { $gte: range.start, $lt: range.end } });
    const expenses = await Expense.find({ date: { $gte: range.start, $lt: range.end } });

    let totalIncome = 0;
    for (const i of incomes) totalIncome += Number(i.amount);

    let totalExpense = 0;
    for (const e of expenses) totalExpense += Number(e.amount);

    return res.json({
      type: "yearly",
      year,
      totalIncome,
      totalExpense,
      balance: totalIncome - totalExpense,
      incomeCount: incomes.length,
      expenseCount: expenses.length,
    });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};


// // GET /api/reports/today
exports.todayReport = async (req, res) => {
  try {
    const now = new Date();

    const year = now.getFullYear();
    const month = now.getMonth() + 1; // 1-12
    const day = now.getDate(); // 1-31

    const start = new Date(year, month - 1, day);
    const end = new Date(year, month - 1, day + 1);

    const incomes = await Income.find({ date: { $gte: start, $lt: end } });
    const expenses = await Expense.find({ date: { $gte: start, $lt: end } });

    let totalIncome = 0;
    for (const i of incomes) totalIncome += Number(i.amount);

    let totalExpense = 0;
    for (const e of expenses) totalExpense += Number(e.amount);

    return res.json({
      type: "today",
      year,
      month,
      day,
      totalIncome,
      totalExpense,
      balance: totalIncome - totalExpense,
      incomeCount: incomes.length,
      expenseCount: expenses.length,
    });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};







