const User = require("../models/userModel"); // Import your User model
const Role = require("../models/roleModel"); // Import your Role model
const Organization = require("../models/organizationModel"); // Import your Organization model
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const secretKey = "Advj-asdlfjoeKAasdjflkekalskldjkcvras-s"; // Replace with your own secret key

exports.login = async (req, res) => {
  try {
        const { email, phone, password } = req.body;
        if (!email && !phone) {
            return res.status(400).json({ error: "Email or phone is required" });
        }

        // Find the user by email or phone in the database
        const user = await User.findOne({ $or: [{ email }, { phoneNumber: phone }] });

        // If the user does not exist, return an error
        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        // Compare the provided password with the hashed password in the database
        const passwordMatch = await bcrypt.compare(password, user.password);

        // If the passwords match, generate a JWT token
        if (passwordMatch) {
            const role = await Role.findById(user.role);
            const organization = await Organization.findOne({ userId: user._id });
            const isOrganization = organization ? true : false;

            const token = jwt.sign({
                sub: {
                    _id: user._id,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    email: user.email,
                    phoneNumber: user.phoneNumber,
                    role: role.name,
                    imageUrl: user.imageUrl,
                    isOrganization
                }
            }, secretKey);

            return res.json({ token });
        } else {
            // If the passwords do not match, return an error
            return res.status(401).json({ error: "Invalid password" });
        }
    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Internal server error" });
    }
};
