const router = require("express").Router();
const { addIncome, getIncomes, deleteIncome } = require("../controllers/income.controller");
const auth = require("../middlewares/auth.middleware");

// All routes here should be protected by auth
router.post("/add-income", auth, addIncome);
router.get("/get-incomes", auth, getIncomes);
router.delete("/delete-income/:id", auth, deleteIncome);

module.exports = router;
