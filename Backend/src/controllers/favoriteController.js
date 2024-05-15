const jwt = require("jsonwebtoken");
const Favorite = require("../models/favoriteModel");
const User = require("../models/userModel");
const Organization = require("../models/organizationModel");

exports.createFavorite = async (req, res) => {
  try {
    const { organizationId } = req.body;
    const user = await User.findById(req.user._id);

    const newFavorite = new Favorite({
      organizationId,
      userId: user._id,
      createdAt: new Date(),
    });

    const savedFavorite = await newFavorite.save();

    res.status(200).json(savedFavorite);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not create favorite" });
  }
};

// Get all favorites by user ID with JWT Token
exports.getAllFavorites = async (req, res) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decoded = jwt.verify(
      token,
      "Advj-asdlfjoeKAasdjflkekalskldjkcvras-s"
    );
    const userId = decoded.sub._id;

    const favorites = await Favorite.find({ userId });

    // Map all organizations from favorites and keep both ids in the object
    const organizations = await Promise.all(
      favorites.map(async (favorite) => {
        const organization = await Organization.findById(
          favorite.organizationId
        );
        return { ...organization._doc, organizationId: organization._id, _id: favorite._id };
      })
    );

    res.status(200).json(organizations);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch favorites" });
  }
};

// Get a favorite by ID
exports.getFavoriteById = async (req, res) => {
  const { id } = req.params;
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decoded = jwt.verify(
      token,
      "Advj-asdlfjoeKAasdjflkekalskldjkcvras-s"
    );
    const userId = decoded.sub._id;

    const favorite = await Favorite.findOne({ _id: id, userId });

    const organization = await Organization.findById(favorite.organizationId);

    if (!organization || !favorite) {
      return res.status(404).json({ error: "Favorite or organization could not be found" });
    }

    res.status(200).json(organization);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch favorite" });
  }
};

// Delete a favorite by ID
exports.deleteFavorite = async (req, res) => {
  try {
    const { id } = req.params;
    const token = req.headers.authorization.split(" ")[1];
    const decoded = jwt.verify(
      token,
      "Advj-asdlfjoeKAasdjflkekalskldjkcvras-s"
    );
    const userId = decoded.sub._id;

    const deletedfavorite = await Favorite.findByIdAndRemove({_id: id, userId});

    if (!deletedfavorite) {
      return res.status(404).json({ error: "Favorite not found" });
    }

    res.status(204).send();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not delete favorite" });
  }
};
