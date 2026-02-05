const router = require("express").Router();
const { getAnalysis } = require("../controllers/report.controller");
const auth = require("../middlewares/auth.middleware");

router.get("/analysis", auth, getAnalysis);

module.exports = router;
