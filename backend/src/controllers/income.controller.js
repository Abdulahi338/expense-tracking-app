const Income = require("../models/Income");

// Add Income
exports.addIncome = async (req, res) => {
    try {
        const { title, amount, category, description, date } = req.body;

        const income = new Income({
            title,
            amount,
            category,
            description,
            date: date || Date.now(),
            user: req.user.id // from auth middleware
        });

        await income.save();

        res.status(200).json({ message: "Income Added", income });
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};

// Get Incomes
exports.getIncomes = async (req, res) => {
    try {
        const incomes = await Income.find({ user: req.user.id }).sort({ createdAt: -1 });
        res.status(200).json(incomes);
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};

// Delete Income
exports.deleteIncome = async (req, res) => {
    try {
        const { id } = req.params;
        const income = await Income.findById(id);

        if (!income) return res.status(404).json({ message: "Income not found" });

        // Validate ownership
        if (income.user.toString() !== req.user.id) {
            return res.status(403).json({ message: "Not authorized to delete this income" });
        }

        await Income.findByIdAndDelete(id);
        res.status(200).json({ message: "Income Deleted" });
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
};
