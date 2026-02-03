const express = require("express");
const router = express.Router();

const { createIncome } = require("../controllers/income.controller");
const { validateIncome } = require("../validators/income.validator");

router.post("/", validateIncome, createIncome);

module.exports = router;
