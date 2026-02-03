const express = require("express");
const mongoose = require("mongoose");
const authRoutes = require("./routes/auth.routes");
const incomeRoutes = require("./routes/income.routes");
const expenseRoutes = require("./routes/expense.routes");
const reportRoutes = require("./routes/report.routes");

const app = express();

app.use(express.json());

// routes
app.use("/api/auth", authRoutes);

// income 
app.use("/api/incomes", incomeRoutes);

//expense
app.use("/api/expenses", expenseRoutes);

// reports
app.use("/api/reports", reportRoutes);


module.exports = app;
