const mongoose = require("mongoose");

const favoriteSchema = new mongoose.Schema({
  id: mongoose.Schema.Types.ObjectId,
  organizationId: mongoose.Schema.Types.ObjectId,
  userId: mongoose.Schema.Types.ObjectId,
  createdAt: Date,
});

const Favorite = mongoose.model("Favorite", favoriteSchema, "favorites");

module.exports = Favorite;
