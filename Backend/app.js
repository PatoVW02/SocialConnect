const express = require("express");
const mongoose = require("mongoose");
const db = require("./config/database");
const authRoutes = require("./src/routes/authRoutes");
const roleRoutes = require("./src/routes/roleRoutes");
const userRoutes = require("./src/routes/userRoutes");
const tagRoutes = require("./src/routes/tagRoutes");
const favoriteRoutes = require("./src/routes/favoriteRoutes");
const postTypeRoutes = require("./src/routes/postTypeRoutes");
const reviewRoutes = require("./src/routes/reviewRoutes");
const organizationRoutes = require("./src/routes/organizationRoutes")
const postRoutes = require("./src/routes/postRoutes");
const fileRoutes = require("./src/routes/fileRoutes");
const swaggerUi = require("swagger-ui-express");
const swaggerSpecs = require("./swagger");
const passport = require("./passport");
const cors = require("cors");
const multer = require("multer");

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());

app.use(express.json());

app.use(passport.initialize());

// Mount routes
app.use("/auth", authRoutes)
app.use("/roles", roleRoutes);
app.use("/users", userRoutes);
app.use("/tags", tagRoutes);
app.use("/favorites", favoriteRoutes);
app.use("/post-types", postTypeRoutes);
app.use("/reviews", reviewRoutes);
app.use("/organizations", organizationRoutes)
app.use("/posts", postRoutes);
app.use("/files", fileRoutes);

// Serve Swagger documentation
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpecs));

// Start the Express server
app.listen(port, "0.0.0.0", () => {
  console.log(`Server is running on port ${port}`);
});
