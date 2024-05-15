const Role = require("../models/roleModel");

exports.createRole = async (req, res) => {
  try {
    const { name, description, permissions } = req.body;

    const newRole = new Role({
        name,
        description,
        permissions
    });

    const savedRole = await newRole.save();

    res.status(200).json(savedRole);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not create role" });
  }
};

// Get all roles
exports.getAllRoles = async (req, res) => {
  try {
    const roles = await Role.find();

    res.status(200).json(roles);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch roles" });
  }
};

// Get a role by ID
exports.getRoleById = async (req, res) => {
  const { id } = req.params;
  try {
    const role = await Role.findById(id);

    if (!role) {
      return res.status(404).json({ error: "Role not found" });
    }

    res.status(200).json(role);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch role" });
  }
};

// Update a role by ID
exports.updateRole = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, permissions } = req.body;

    const updatedRole = await Role.findByIdAndUpdate(
      id,
      { name, description, permissions },
      { new: true }
    );

    if (!updatedRole) {
      return res.status(404).json({ error: "Role not found" });
    }

    return res.status(200).json(updatedRole);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not update role" });
  }
};

// Delete a role by ID
exports.deleteRole = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedRole = await Role.findByIdAndRemove(id);

    if (!deletedRole) {
      return res.status(404).json({ error: "Role not found" });
    }

    res.status(204).send();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not delete role" });
  }
};
