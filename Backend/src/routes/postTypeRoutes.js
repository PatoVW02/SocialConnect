/**
 * @swagger
 * tags:
 *   name: PostTypes
 *   description: Post Type management
 */

/**
 * @swagger
 * /post-types:
 *   get:
 *     summary: Get all post types
 *     tags: [PostTypes]
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/models/PostType'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /post-types:
 *   post:
 *     summary: Create a new post type
 *     tags: [PostTypes]
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
 *         description: Post type created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/PostType'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /post-types/{id}:
 *   delete:
 *     summary: Delete a post type by ID
 *     tags: [PostTypes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the post type to delete
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: Post type deleted successfully
 *       404:
 *         description: Post type not found
 *       500:
 *         description: Internal server error
 */

const express = require("express");
const router = express.Router();
const postTypeController = require("../controllers/postTypeController");
const passport = require("passport");

// Create a new post type
router.post(
  "/",
  passport.authenticate("jwt", { session: false }),
  postTypeController.createPostType
);

// Get all post types
router.get("/", postTypeController.getAllPostTypes);

// Delete a post type by ID
router.delete(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  postTypeController.deletePostType
);

module.exports = router;
