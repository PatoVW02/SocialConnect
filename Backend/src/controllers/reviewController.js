const Review = require("../models/reviewModel");

exports.createReview = async (req, res) => {
  try {
    const { organizationId, userId, content, rating } = req.body;

    const newReview = new Review({
        organizationId,
        userId,
        content,
        rating,
        createdAt: new Date(),
    });

    const savedReview = await newReview.save();

    res.status(200).json(savedReview);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not create review" });
  }
};

// Get all reviews
exports.getAllReviews = async (req, res) => {
  try {
    const { organizationId } = req.query;

    const Reviews = await Review.find({ organizationId });

    res.status(200).json(Reviews);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch reviews" });
  }
};

// Get a review by ID
exports.getReviewById = async (req, res) => {
  const { id } = req.params;
  try {
    const Review = await Review.findById(id);

    if (!Review) {
      return res.status(404).json({ error: "Review not found" });
    }

    res.status(200).json(Review);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch review" });
  }
};

// Update a review by ID
exports.updateReview = async (req, res) => {
  try {
    const { id } = req.params;
    const { content, rating } = req.body;

    const updatedReview = await Review.findByIdAndUpdate(
      id,
      { content, rating },
      { new: true }
    );

    if (!updatedReview) {
      return res.status(404).json({ error: "Review not found" });
    }

    return res.status(200).json(updatedReview);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not update review" });
  }
};

// Delete a review by ID
exports.deleteReview = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedReview = await Review.findByIdAndRemove(id);

    if (!deletedReview) {
      return res.status(404).json({ error: "Review not found" });
    }

    res.status(204).send();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not delete review" });
  }
};
