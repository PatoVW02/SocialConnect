const User = require("../models/userModel");
const Organization = require("../models/organizationModel");
const Favorite = require("../models/favoriteModel");
const { hashPassword } = require("../services/passwordService");

exports.createOrganization = async (req, res) => {
    try {
        const {
            email,
            phoneNumber
        } = req.body.contact

        const {
            name,
            userName,
            description,
            password,
            logoUrl,
            videoUrl,
            bannerUrl,
            address,
            contact,
            rfc,
            schedule,
            socialNetworks,
            tags,
            role
        } = req.body;

        const hashedPassword = await hashPassword(password);
        const newUser = new User({
            firstName: name,
            lastName: "",
            email,
            phoneNumber,
            password: hashedPassword,
            tags,
            role,
            imageUrl: logoUrl,
        });

        const savedUser = await newUser.save();

        const newOrganization = new Organization({
            userId: savedUser['_id'],
            name,
            userName,
            address,
            contact,
            description,
            rfc,
            schedule,
            socialNetworks,
            logoUrl,
            videoUrl,
            bannerUrl,
            tags,
            createdAt: new Date(),
            updatedAt: new Date()
        });

        const savedOrganization = await newOrganization.save();

        return res.status(200).json(savedOrganization);
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Could not create organization" });
    }
};

// Get all organizations
exports.getAllOrganizations = async (req, res) => {
    try {
        const { tags, useUserTags } = req.query;

        const user = await User.findById(req.user._id);
        const favorites = await Favorite.find({ userId: user._id });
        const favoriteIds = favorites.map(favorite => favorite.organizationId.toString());

        if (useUserTags === true || useUserTags === "true" || useUserTags === "1" || useUserTags === 1) {
            const organizations = await Organization.find({ tags: { $in: user.tags } });

            const filteredOrganizations = organizations.filter(organization => !favoriteIds.includes(organization._id.toString()));

            return res.status(200).json(filteredOrganizations);
        } else {
            if (tags && tags.length > 0 && tags[0].length > 0) {
                const organizations = await Organization.find({ tags: { $in: tags } });

                const filteredOrganizations = organizations.filter(organization => !favoriteIds.includes(organization._id.toString()));

                return res.status(200).json(filteredOrganizations);
            } else {
                const organizations = await Organization.find();

                return res.status(200).json(organizations);
            }
        }
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Could not fetch organizations" });
    }
};

// Get a organization by ID
exports.getOrganizationById = async (req, res) => {
  const { id } = req.params;
  try {
    const organization = await Organization.findById(id);

    if (!organization) {
      return res.status(404).json({ error: "Organization not found" });
    }

    res.status(200).json(organization);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Could not fetch organization" });
  }
};

// Update a organization by ID
exports.updateOrganization = async (req, res) => {
    try {
        const { id } = req.params;
        const {
            name,
            description,
            logoUrl,
            address,
            contact,
            socialNetworks,
            tags
        } = req.body;

        const updatedOrganization = await Organization.findByIdAndUpdate(
            id,
            { name, description, logoUrl, address, contact, socialNetworks, tags },
            { new: true }
        );

        if (!updatedOrganization) {
            return res.status(404).json({ error: "Organization not found" });
        }

        return res.status(200).json(updatedOrganization);
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Could not update organization" });
    }
};

// Delete a organization by ID
exports.deleteOrganization = async (req, res) => {
    try {
        const { id } = req.params;

        const deletedorganization = await Organization.findByIdAndRemove(id);

        if (!deletedorganization) {
        return res.status(404).json({ error: "Organization not found" });
        }

        res.status(204).send();
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Could not delete organization" });
    }
};
