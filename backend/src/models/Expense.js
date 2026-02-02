const mongoose = require("mongoose");

const expenseSchema = new mongoose.Schema(
  {
    amount: {
      type: Number,
      required: true,
    },
    category: {
      type: String,
      required: true, // e.g. Food, Transport
    },
    paymentMethod: {
      type: String,
      required: true, // Cash, Bank, Mobile Money
    },
    date: {
      type: Date,
      required: true,
    },
    description: {
      type: String,
      default: "",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Expense", expenseSchema);
