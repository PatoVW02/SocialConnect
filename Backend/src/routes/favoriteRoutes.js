/**
 * @swagger
 * tags:
 *   name: Favorites
 *   description: Favorites management
 */

/**
 * @swagger
 * /favorites:
 *   get:
 *     summary: Get all favorites
 *     tags: [Favorites]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/models/Favorite'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /favorites/{id}:
 *   get:
 *     summary: Get a favorite by ID
 *     tags: [Favorites]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the favorite to retrieve
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Favorite'
 *       404:
 *         description: Favorite not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /favorites:
 *   post:
 *     summary: Create a new favorite
 *     tags: [Favorites]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               organizationId:
 *                 type: string
 *     responses:
 *       200:
 *         description: Favorite created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Favorite'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /favorites/{id}:
 *   delete:
 *     summary: Delete a favorite by ID
 *     tags: [Favorites]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the favorite to delete
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: Favorite deleted successfully
 *       404:
 *         description: Favorite not found
 *       500:
 *         description: Internal server error
 */

const express = require("express");
const router = express.Router();
const favoriteController = require("../controllers/favoriteController");
const passport = require("passport");

// Create a new favorite
router.post(
  "/",
  passport.authenticate("jwt", { session: false }),
  favoriteController.createFavorite
);

// Get all favorites
router.get(
  "/",
  passport.authenticate("jwt", { session: false }),
  favoriteController.getAllFavorites
);

// Get a favorite by ID
router.get(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  favoriteController.getFavoriteById
);

// Delete a favorite by ID
router.delete(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  favoriteController.deleteFavorite
);

module.exports = router;
