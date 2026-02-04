const router = require("express").Router();
const { addExpense, getExpenses, deleteExpense } = require("../controllers/expense.controller");
const auth = require("../middlewares/auth.middleware");

// All routes here should be protected by auth
router.post("/add-expense", auth, addExpense);
router.get("/get-expenses", auth, getExpenses);
router.delete("/delete-expense/:id", auth, deleteExpense);

module.exports = router;
