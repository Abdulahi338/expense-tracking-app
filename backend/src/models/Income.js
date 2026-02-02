const mongoose = require("mongoose");

const incomeSchema = new mongoose.Schema(
  {
    amount: {
      type: Number,
      required: true,
    },
    source: {
      type: String,
      required: true, // e.g. Salary, Business
    },
    paymentMethod: {
      type: String,
      required: true, // e.g. Cash, Bank, Mobile Money
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

module.exports = mongoose.model("Income", incomeSchema);
