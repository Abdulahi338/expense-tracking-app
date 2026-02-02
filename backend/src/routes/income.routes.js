const express = require("express");
const router = express.Router();
const incomeController = require("../controllers/income.controller");

// CREATE income
router.post("/", incomeController.createIncome);

// READ all incomes
router.get("/", incomeController.getIncomes);

// UPDATE income
router.put("/:id", incomeController.updateIncome);

// DELETE income
router.delete("/:id", incomeController.deleteIncome);

module.exports = router;
