const express = require("express");
const mongoose = require("mongoose");
const authRoutes = require("./routes/auth.routes");

const app = express();

app.use(express.json());

// routes
app.use("/api/auth", authRoutes);

module.exports = app;
