// swagger.js

const swaggerJsdoc = require("swagger-jsdoc");

const options = {
  definition: {
    openapi: "3.0.0", // Specify the OpenAPI version
    info: {
      title: "My Express API", // Title of your API
      version: "1.0.0", // Version of your API
      description: "API documentation for My Express API", // Description of your API
    },
  },
  // Specify the paths to the API routes
  apis: ["./src/routes/*.js"],
};

// Generate Swagger documentation
const specs = swaggerJsdoc(options);

module.exports = specs;
