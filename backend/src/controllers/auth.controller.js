const User = require("../models/User");
const bcrypt = require("bcryptjs");

/* ===== REGISTER ===== */
exports.register = async (req, res) => {
  try {
    const { username, email, password } = req.body;
exports.login = async (req, res) => {
  try {
    const { email, password, role } = req.body;

    // Hubi email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "Email not found" });
    }

    // Hubi password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Wrong password" });
    }

    // Hubi role haddii la soo diro
    if (role && user.role !== role) {
      return res.status(403).json({ message: "Role not allowed" });
    }

    res.json({
      message: "Login successful",
      user: {
        id: user._id,
        username: user.username,
        role: user.role,
      },
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

    const exist = await User.findOne({ email, username });
    if (exist) {
      return res.json({ message: "User already exists" });
    }

    

    const hashed = await bcrypt.hash(password, 10);

    const user = new User({
      username,
      email,
      password: hashed,
    });

    await user.save();
    res.json({ message: "User registered successfully" });

  } catch (err) {
    res.json({ error: err.message });
  }
};

/* ===== LOGIN ===== */
exports.login = async (req, res) => {
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
};
