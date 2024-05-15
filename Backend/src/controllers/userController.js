const User = require('../models/userModel');
const Tag = require('../models/tagModel');
const { hashPassword } = require('../services/passwordService');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');

exports.createUser = async (req, res) => {
  try {
    const { firstName, lastName, email, phoneNumber, password, tags, role, imageUrl } = req.body;
    const hashedPassword = await hashPassword(password);

    const newUser = new User({
      firstName,
      lastName,
      email,
      phoneNumber,
      password: hashedPassword,
      tags,
      role,
      imageUrl,
    });

    const savedUser = await newUser.save();

    res.status(200).json(savedUser);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Could not create user' });
  }
};


// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find();

    res.status(200).json(users);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Could not fetch users" });
  }
};

// Get a user by ID
exports.getUserById = async (req, res) => {
  const { id } = req.params;

  try {
    const user = await User.findById(id);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.status(200).json(user);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Could not fetch user" });
  }
};

// Get a user's tags by ID
exports.getUserTags = async (req, res) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwt.verify(
      token,
      "Advj-asdlfjoeKAasdjflkekalskldjkcvras-s"
    );

    if (!decodedToken.sub || !decodedToken.sub._id) {
      return res.status(400).json({ error: "Invalid token" });
    }

    const userId = decodedToken.sub._id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (
      !Array.isArray(user.tags) ||
      !user.tags.every(mongoose.Types.ObjectId.isValid)
    ) {
      return res.status(400).json({ error: "Invalid tag data" });
    }

    const tags = await Tag.find({ _id: { $in: user.tags } });

    res.status(200).json(tags);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Could not fetch user tags" });
  }
};

// Update a user by ID
exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { firstName, lastName, phoneNumber, password, tags, role } = req.body;

    const updatedUser = await User.findByIdAndUpdate(
      id,
      { firstName, lastName, phoneNumber, password, tags, role },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(404).json({ error: "User not found" });
    }

    return res.status(200).json(updatedUser);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Could not update user" });
  }
};

// Update a user's tags by ID
exports.updateUserTags = async (req, res) => {
  try {
    const { tags } = req.body;

    const token = req.headers.authorization.split(" ")[1];
    const decodedToken = jwt.verify(
      token,
      "Advj-asdlfjoeKAasdjflkekalskldjkcvras-s"
    );

    if (!decodedToken.sub || !decodedToken.sub._id) {
      return res.status(400).json({ error: "Invalid token" });
    }

    const userId = decodedToken.sub._id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Map tag id string to ObjectId
    const tagIds = tags.map((tagId) => new mongoose.Types.ObjectId(tagId));

    user.tags = tagIds;
    const updatedUser = await user.save();

    return res.status(200).json(updatedUser);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Could not update user" });
  }
}

// Delete a user by ID
exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedUser = await User.findByIdAndRemove(id);

    if (!deletedUser) {
      return res.status(404).json({ error: "User not found" });
    }

    res.status(204).send();
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Could not delete user" });
  }
};
