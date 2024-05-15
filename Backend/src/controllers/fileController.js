const jwt = require("jsonwebtoken");
const File = require("../models/fileModel");
const Organization = require("../models/organizationModel");

exports.createFile = async (req, res) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decoded = jwt.verify(
      token,
      "Advj-asdlfjoeKAasdjflkekalskldjkcvras-s"
    );

    const userId = decoded.sub._id;

    const organizationFound = await Organization.findOne({ userId });

    if (!organizationFound) {
      return res.status(404).json({ error: "Organization not found" });
    }

    const file = req.file;

    if (!file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const fileContentBase64 = file.buffer.toString("base64");

    const newFile = new File({
      organizationId: organizationFound._id,
      name: req.file.originalname,
      content: fileContentBase64,
      size: req.file.size,
      type: req.file.mimetype,
      createdAt: new Date(),
    });

    const savedFile = await newFile.save();

    res.status(200).json(savedFile);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not create file" });
  }
};

// Get all Files
exports.getAllFiles = async (req, res) => {
  try {
    const { organizationId } = req.query;

    const Files = await File.find({ organizationId });

    res.status(200).json(Files);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch files" });
  }
};

// Get a File by ID
exports.getFileById = async (req, res) => {
  const { id } = req.params;
  try {
    const File = await File.findById(id);

    if (!File) {
      return res.status(404).json({ error: "File not found" });
    }

    res.status(200).json(File);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not fetch file" });
  }
};

// Delete a File by ID
exports.deleteFile = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedFile = await File.findByIdAndRemove(id);

    if (!deletedFile) {
      return res.status(404).json({ error: "File not found" });
    }

    res.status(204).send();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Could not delete file" });
  }
};
