const Income = require("../models/Income");

// POST /api/incomes
exports.createIncome = async (req, res) => {
  try {
    const { amount, source, paymentMethod, date, description } = req.body;

    // basic validation
    if (!amount || !source || !paymentMethod || !date) {
      return res.status(400).json({ message: "Please fill required fields" });
    }

    const income = await Income.create({
      amount,
      source,
      paymentMethod,
      date,
      description,
    });

    return res.status(201).json(income);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// GET /api/incomes
exports.getIncomes = async (req, res) => {
  try {
    const incomes = await Income.find().sort({ date: -1 });
    return res.json(incomes);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// PUT /api/incomes/:id
exports.updateIncome = async (req, res) => {
  try {
    const { id } = req.params;

    const updated = await Income.findByIdAndUpdate(id, req.body, {
      new: true,
    });

    if (!updated) {
      return res.status(404).json({ message: "Income not found" });
    }

    return res.json(updated);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// DELETE /api/incomes/:id
exports.deleteIncome = async (req, res) => {
  try {
    const { id } = req.params;

    const deleted = await Income.findByIdAndDelete(id);

    if (!deleted) {
      return res.status(404).json({ message: "Income not found" });
    }

    return res.json({ message: "Income deleted successfully" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};
