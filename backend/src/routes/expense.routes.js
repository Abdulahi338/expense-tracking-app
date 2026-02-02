const express = require("express");
const router = express.Router();
const expenseController = require("../controllers/expense.controller");

// CREATE expense
router.post("/", expenseController.createExpense);

// READ all expenses
router.get("/", expenseController.getExpenses);

// UPDATE expense
router.put("/:id", expenseController.updateExpense);

// DELETE expense
router.delete("/:id", expenseController.deleteExpense);

module.exports = router;
