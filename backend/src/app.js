const express = require("express");
const mongoose = require("mongoose");
const authRoutes = require("./routes/auth.routes");

const app = express();

app.use(express.json());
const cors = require("cors");
app.use(cors());
// routes
// routes
app.use("/api/auth", authRoutes);
app.use("/api/incomes", require("./routes/income.routes"));
app.use("/api/expenses", require("./routes/expense.routes"));
app.use("/api/reports", require("./routes/report.routes"));
module.exports = app;
