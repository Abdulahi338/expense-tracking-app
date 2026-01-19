const express = require("express");
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const router = express.Router();

/* ===== USER MODEL ===== */
const UserSchema = new mongoose.Schema({
  username: String,
  email: String,
  password: String
});

const User = mongoose.model("User", UserSchema);

/* ===== REGISTER ===== */
router.post("/register", async (req, res) => {
  try {
    const { username, email, password } = req.body;

    // Check user exists
    const exist = await User.findOne({ email });
    if (exist) {
      return res.json({ message: "User already exists" });
    }

    // Hash password
    const hashed = await bcrypt.hash(password, 10);

    const user = new User({
      username,
      email,
      password: hashed
    });

    await user.save();
    res.json({ message: "User registered successfully" });

  } catch (err) {
    res.json({ error: err.message });
  }
});

/* ===== LOGIN ===== */
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.json({ message: "User not found" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.json({ message: "Wrong password" });
    }

    res.json({ message: "Login successful" });

  } catch (err) {
    res.json({ error: err.message });
  }
});

module.exports = router;
