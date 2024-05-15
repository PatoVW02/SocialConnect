const mongoose = require("mongoose");

const roleSchema = new mongoose.Schema({
  id: mongoose.Schema.Types.ObjectId,
  name: String,
  description: String,
  permissions: [String]
});

const Role = mongoose.model("Role", roleSchema, "roles");

module.exports = Role;
