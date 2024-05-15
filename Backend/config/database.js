// config/database.js

const mongoose = require("mongoose");

// MongoDB connection URL
const dbURL =
  process.env.MONGODB_URI ||
  "mongodb+srv://a00834526:KXwo6175FNtI3VqB@cluster0.x40ar8w.mongodb.net/dev";

mongoose.connect(dbURL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const db = mongoose.connection;

db.on("error", console.error.bind(console, "MongoDB connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
});

module.exports = db;
