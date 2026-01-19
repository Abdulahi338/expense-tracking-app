const express = require("express");
const mongoose = require("mongoose");
const authRoutes = require("./auth");

const app = express();

// si JSON loo akhriyo
app.use(express.json());

// Routes
app.use("/auth", authRoutes);

// MongoDB connect
mongoose.connect("mongodb://127.0.0.1:27017/simpleauth")
  .then(() => console.log("MongoDB Connected"))
  .catch(err => console.log(err));

// Server
app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});
