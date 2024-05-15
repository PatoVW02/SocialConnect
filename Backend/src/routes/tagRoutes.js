/**
 * @swagger
 * tags:
 *   name: Tags
 *   description: Tag management
 */

/**
 * @swagger
 * /tags:
 *   get:
 *     summary: Get all tags
 *     tags: [Tags]
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/models/Tag'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /tags/{id}:
 *   get:
 *     summary: Get a tag by ID
 *     tags: [Tags]
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the tag to retrieve
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Tag'
 *       404:
 *         description: Tag not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /tags:
 *   post:
 *     summary: Create a new tag
 *     tags: [Tags]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *     responses:
 *       200:
 *         description: Tag created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Tag'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /tags/{id}:
 *   put:
 *     summary: Update a tag by ID
 *     tags: [Tags]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the tag to update
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               createdAt:
 *                 type: string
 *               updatedAt:
 *                 type: string
 *     responses:
 *       200:
 *         description: Tag updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Tag'
 *       404:
 *         description: Tag not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /tags/{id}:
 *   delete:
 *     summary: Delete a tag by ID
 *     tags: [Tags]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the tag to delete
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: Tag deleted successfully
 *       404:
 *         description: Tag not found
 *       500:
 *         description: Internal server error
 */

const express = require("express");
const router = express.Router();
const tagController = require("../controllers/tagController");
const passport = require('passport');

// Create a new tag
router.post(
  "/",
  passport.authenticate("jwt", { session: false }),
  tagController.createTag
);

// Get all tags
router.get("/", tagController.getAllTags);

// Get a tag by ID
router.get("/:id", tagController.getTagById);

// Update a tag by ID
router.put("/:id", passport.authenticate("jwt", { session: false }), tagController.updateTag);

// Delete a tag by ID
router.delete("/:id", passport.authenticate("jwt", { session: false }), tagController.deleteTag);

module.exports = router;
