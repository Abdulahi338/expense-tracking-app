const Expense = require("../models/Expense");
const Income = require("../models/Income");

exports.createExpense = async (req, res) => {
  try {
    const { amount, category, paymentMethod, date, description } = req.body;

    //validation
    if (!amount || !category || !paymentMethod || !date) {
      return res.status(400).json({ message: "Please fill all required fields" });
    }

    //  incomes
    const incomes = await Income.find();
    let totalIncome = 0;

    for (let inc of incomes) {
      totalIncome += inc.amount;
    }

    //  expenses
    const expenses = await Expense.find();
    let totalExpense = 0;

    for (let exp of expenses) {
      totalExpense += exp.amount;
    }

    // calculate balance
    const balance = totalIncome - totalExpense;

    // check balance
    if (amount > balance) {
      return res.status(400).json({
        message: "Insufficient balance. Please add income first.",
        balance: balance,
      });
    }

    // save expense
    const expense = await Expense.create({
      amount,
      category,
      paymentMethod,
      date,
      description,
    });

    return res.status(201).json(expense);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// READ all expenses
exports.getExpenses = async (req, res) => {
  try {
    const expenses = await Expense.find().sort({ date: -1 });
    return res.json(expenses);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// UPDATE expense
exports.updateExpense = async (req, res) => {
  try {
    const { id } = req.params;

    const updated = await Expense.findByIdAndUpdate(id, req.body, {
      new: true,
    });

    if (!updated) {
      return res.status(404).json({ message: "Expense not found" });
    }

    return res.json(updated);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// DELETE expense
exports.deleteExpense = async (req, res) => {
  try {
    const { id } = req.params;

    const deleted = await Expense.findByIdAndDelete(id);

    if (!deleted) {
      return res.status(404).json({ message: "Expense not found" });
    }

    return res.json({ message: "Expense deleted successfully" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

