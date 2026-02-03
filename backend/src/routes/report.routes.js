const express = require("express");
const router = express.Router();
const reportController = require("../controllers/report.controller");

router.get("/today", reportController.todayReport);
router.get("/daily", reportController.dailyReport);
router.get("/monthly", reportController.monthlyReport);
router.get("/yearly", reportController.yearlyReport);

module.exports = router;
