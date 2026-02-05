const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  username: String,
  email: String,
  password: String,
  resetCode: String,
  resetCodeExpires: Date
});

module.exports = mongoose.model("User", UserSchema);
