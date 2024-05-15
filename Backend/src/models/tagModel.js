const mongoose = require("mongoose");

const tagSchema = new mongoose.Schema({
    id: mongoose.Schema.Types.ObjectId,
    name: String,
    description: String,
    createdAt: Date,
    updatedAt: Date,
    updatedBy: mongoose.Schema.Types.ObjectId
});

const Tag = mongoose.model("Tag", tagSchema, "tags");

module.exports = Tag;
