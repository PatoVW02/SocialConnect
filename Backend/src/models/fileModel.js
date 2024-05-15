const mongoose = require("mongoose");

const fileSchema = new mongoose.Schema({
    id: mongoose.Schema.Types.ObjectId,
    organizationId: mongoose.Schema.Types.ObjectId,
    name: String,
    content: String,
    size: Number,
    type: String,
    createdAt: Date
});

const File = mongoose.model("File", fileSchema, "files");

module.exports = File;
