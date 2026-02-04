const express = require("express");
const mongoose = require("mongoose");
const authRoutes = require("./routes/auth.routes");

const app = express();

app.use(express.json());


const cors = require("cors");
app.use(cors());
app.use(express.json());

// routes
// routes
app.use("/api/auth", authRoutes);
app.use("/api/incomes", require("./routes/income.routes"));
app.use("/api/expenses", require("./routes/expense.routes"));

module.exports = app;
