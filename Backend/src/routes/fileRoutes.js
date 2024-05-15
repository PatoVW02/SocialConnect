/**
 * @swagger
 * tags:
 *   name: Files
 *   description: Files management
 */

/**
 * @swagger
 * /files:
 *   get:
 *     summary: Get all files
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: organizationId
 *         in: query
 *         required: true
 *     description: Organization ID of the files to retrieve
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/models/File'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /files/{id}:
 *   get:
 *     summary: Get a file by ID
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the file to retrieve
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/File'
 *       404:
 *         description: file not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /files:
 *   post:
 *     summary: Create a new file
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:  # Use multipart/form-data for file uploads
 *           schema:
 *             type: object
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *     responses:
 *       200:
 *         description: File created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/File'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /files/{id}:
 *   delete:
 *     summary: Delete a file by ID
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the file to delete
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: file deleted successfully
 *       404:
 *         description: file not found
 *       500:
 *         description: Internal server error
 */

const express = require("express");
const os = require("os");
const router = express.Router();
const multer = require("multer");
const fileController = require("../controllers/fileController");
const passport = require("passport");
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Create a new file
router.post(
  "/",
  passport.authenticate("jwt", { session: false }),
  upload.single("file"),
  fileController.createFile
);

// Get all files
router.get(
  "/",
  passport.authenticate("jwt", { session: false }),
  fileController.getAllFiles
);

// Get a file by ID
router.get(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  fileController.getFileById
);

// Delete a file by ID
router.delete(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  fileController.deleteFile
);

module.exports = router;
