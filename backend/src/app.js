const express = require("express");
const mongoose = require("mongoose");
const authRoutes = require("./routes/auth.routes");
const incomeRoutes = require("./routes/income.routes");
const expenseRoutes = require("./routes/expense.routes");

const app = express();

app.use(express.json());

// routes
app.use("/api/auth", authRoutes);

// income 
app.use("/api/incomes", incomeRoutes);

//expense
app.use("/api/expenses", expenseRoutes);


module.exports = app;
