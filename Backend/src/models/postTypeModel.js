const mongoose = require("mongoose");

const postTypeSchema = new mongoose.Schema({
  id: mongoose.Schema.Types.ObjectId,
  name: String,
  description: String,
  createdAt: Date,
});

const PostType = mongoose.model("PostType", postTypeSchema, "postTypes");

module.exports = PostType;
