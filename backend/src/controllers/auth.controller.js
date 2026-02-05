const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET;

/* ===== REGISTER ===== */
exports.register = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    const exist = await User.findOne({ email });
    if (exist) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashed = await bcrypt.hash(password, 10);

    const user = new User({
      username,
      email,
      password: hashed,
    });

    await user.save();
    res.status(201).json({ message: "User registered successfully" });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ===== LOGIN ===== */
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Hubi email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    // Hubi password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Wrong password" });
    }

    const token = jwt.sign(
      { id: user._id, role: user.role || 'user' },
      JWT_SECRET,
      { expiresIn: "1h" }
    );

    res.json({
      message: "Login successful",
      token,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        role: user.role,
      },
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ===== FORGOT PASSWORD ===== */
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Generate random 4-digit code
    const code = Math.floor(1000 + Math.random() * 9000).toString();

    // Save to user (valid for 10 mins)
    user.resetCode = code;
    user.resetCodeExpires = Date.now() + 10 * 60 * 1000;
    await user.save();

    // In a real app, you would send an email/SMS here.
    // For this demo, we return it so the frontend can show a notification.
    res.json({ message: "Verification code generated", code });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* ===== VERIFY OTP ===== */
exports.verifyOTP = async (req, res) => {
  try {
    const { email, code } = req.body;
    const user = await User.findOne({
      email,
      resetCode: code,
      resetCodeExpires: { $gt: Date.now() }
    });

    if (!user) {
      return res.status(400).json({ message: "Invalid or expired code" });
    }

    // Code is valid - in a real app you might return a one-time token for reset
    res.json({ message: "Code verified successfully" });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
