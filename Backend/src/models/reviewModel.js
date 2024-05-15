const mongoose = require("mongoose");

const reviewModel = new mongoose.Schema({
    id: mongoose.Schema.Types.ObjectId,
    organizationId: String,
    userId: String,
    content: String,
    rating: mongoose.Schema.Types.Decimal128,
    createdAt: Date,
    updatedAt: Date
});

const Review = mongoose.model("Review", reviewModel, "reviews");

module.exports = Review;
