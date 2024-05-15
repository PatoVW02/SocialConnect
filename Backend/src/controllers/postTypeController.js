const PostType = require("../models/postTypeModel");

exports.createPostType = async (req, res) => {
  try {
    const { name, description } = req.body;

    const newPostType = new PostType({
      name,
      description,
      createdAt: new Date(),
    });

    const savedPostType = await newPostType.save();

    res.status(200).json(savedPostType);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not create post type" });
  }
};

// Get all post types
exports.getAllPostTypes = async (req, res) => {
  try {
    const postTypes = await PostType.find();

    res.status(200).json(postTypes);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch post types" });
  }
};

// Delete a post type by ID
exports.deletePostType = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedPostType = await PostType.findByIdAndRemove(id);

    if (!deletedPostType) {
      return res.status(404).json({ error: "Post type not found" });
    }

    res.status(204).send();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not delete post type" });
  }
};
