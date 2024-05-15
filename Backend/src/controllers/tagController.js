const Tag = require('../models/tagModel');

// Create a tag
exports.createTag = async (req, res) => {
  try {
    const { name, description } = req.body;
    const newTag = new Tag({ name, description });

    const savedTag = await newTag.save();

    res.status(200).json(savedTag);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Could not create tag' });
  }
};

// Get all tags
exports.getAllTags = async (req, res) => {
  try {
    const tags = await Tag.find();

    res.status(200).json(tags);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch tags" });
  }
};

// Get a tag by ID
exports.getTagById = async (req, res) => {
    try {
        const { id } = req.params;
        const tag = await Tag.findById(id);

        if (!tag) {
            return res.status(404).json({ error: "Tag not found" });
        }

        res.status(200).json(tag);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Could not fetch tag" });
    }
}

// Update a tag by ID
exports.updateTag = async (req, res) => {
    try {
        const { id } = req.params;
        const { name, description } = req.body;

        const updatedTag = await Tag.findByIdAndUpdate(
            id,
            { name, description },
            { new: true }
        );

        if (!updatedTag) {
            return res.status(404).json({ error: "Tag not found" });
        }

        res.status(200).json(updatedTag);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Could not update tag" });
    }
}

// Delete a tag by ID
exports.deleteTag = async (req, res) => {
    try {
        const { id } = req.params;
        const deletedTag = await Tag.findByIdAndDelete(id);

        if (!deletedTag) {
            return res.status(404).json({ error: "Tag not found" });
        }

        res.status(204).json();
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Could not delete tag" });
    }
}
