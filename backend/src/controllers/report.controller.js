const Income = require("../models/Income");
const Expense = require("../models/Expense");

// helper: build date range
function getRange(type, year, month, day) {
  if (type === "daily") {
    const start = new Date(year, month - 1, day);
    const end = new Date(year, month - 1, day + 1);
    return { start, end };
  }

  if (type === "monthly") {
    const start = new Date(year, month - 1, 1);
    const end = new Date(year, month, 1);
    return { start, end };
  }

  if (type === "yearly") {
    const start = new Date(year, 0, 1);
    const end = new Date(year + 1, 0, 1);
    return { start, end };
  }

  return null;
}


