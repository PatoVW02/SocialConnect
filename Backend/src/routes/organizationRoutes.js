/**
 * @swagger
 * tags:
 *   name: Organizations
 *   description: Organization management
 */

/**
 * @swagger
 * /organizations:
 *   get:
 *     summary: Get all organizations
 *     tags: [Organizations]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: tags
 *         in: query
 *         required: false
 *         description: Tags of the organizations to retrieve
 *         schema:
 *           type: array
 *           items:
 *             type: string
 *       - name: useUserTags
 *         in: query
 *         required: true
 *         description: Whether to use the user's tags or not
 *         schema:
 *           type: boolean
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/models/Organization'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /organizations/{id}:
 *   get:
 *     summary: Get a organization by ID
 *     tags: [Organizations]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the organization to retrieve
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Organization'
 *       404:
 *         description: Organization not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     Address:
 *       type: object
 *       properties:
 *         street1:
 *           type: string
 *         street2:
 *           type: string
 *         city:
 *           type: string
 *         state:
 *           type: string
 *         zipCode:
 *           type: string
 *         country:
 *           type: string
 *
 *     Contact:
 *       type: object
 *       properties:
 *         email:
 *           type: string
 *         phoneNumber:
 *           type: string
 *
 * /organizations:
 *   post:
 *     summary: Create a new organization
 *     tags: [Organizations]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               userName:
 *                 type: string
 *               description:
 *                 type: string
 *               password:
 *                 type: string
 *               logoUrl:
 *                 type: string
 *               bannerUrl:
 *                 type: string
 *               videoUrl:
 *                 type: string
 *               address:
 *                 $ref: '#/components/schemas/Address'
 *               contact:
 *                 $ref: '#/components/schemas/Contact'
 *               rfc:
 *                 type: string
 *               schedule:
 *                 type: string
 *               socialNetworks:
 *                 type: array
 *                 items:
 *                   type: object  # Define the structure of each object
 *                   properties:
 *                     name:
 *                       type: string
 *                     url:
 *                       type: string
 *               role:
 *                 type: string
 *               tags:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       200:
 *         description: Organization created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Organization'
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     Address:
 *       type: object
 *       properties:
 *         street1:
 *           type: string
 *         street2:
 *           type: string
 *         city:
 *           type: string
 *         state:
 *           type: string
 *         zipCode:
 *           type: string
 *         country:
 *           type: string
 *
 *     Contact:
 *       type: object
 *       properties:
 *         email:
 *           type: string
 *         phoneNumber:
 *           type: string
 *
 * /organizations/{id}:
 *   put:
 *     summary: Update a organization by ID
 *     tags: [Organizations]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the organization to update
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
 *               logoUrl:
 *                 type: string
 *               address:
 *                 $ref: '#/components/schemas/Address'
 *               contact:
 *                 $ref: '#/components/schemas/Contact'
 *               socialNetworks:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     name:
 *                       type: string
 *                     url:
 *                       type: string
 *               tags:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       200:
 *         description: Organization updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/models/Organization'
 *       404:
 *         description: Organization not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /organizations/{id}:
 *   delete:
 *     summary: Delete a organization by ID
 *     tags: [Organizations]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the organization to delete
 *         schema:
 *           type: string
 *     responses:
 *       204:
 *         description: Organization deleted successfully
 *       404:
 *         description: Organization not found
 *       500:
 *         description: Internal server error
 */

const express = require("express");
const router = express.Router();
const organizationController = require("../controllers/organizationController");
const passport = require("passport");

// Create a new organization
router.post("/", organizationController.createOrganization);

// Get all organizations
router.get(
  "/",
  passport.authenticate("jwt", { session: false }),
  organizationController.getAllOrganizations
);

// Get a organization by ID
router.get(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  organizationController.getOrganizationById
);

// Update a organization by ID
router.put(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  organizationController.updateOrganization
);

// Delete a organization by ID
router.delete(
  "/:id",
  passport.authenticate("jwt", { session: false }),
  organizationController.deleteOrganization
);

module.exports = router;
