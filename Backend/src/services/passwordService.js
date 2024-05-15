const bcrypt = require("bcrypt");
const saltRounds = 10; // Adjust the number of salt rounds as needed

/**
 * Hashes a password using bcrypt.
 * @param {string} password - The plaintext password to hash.
 * @returns {Promise<string>} - A promise that resolves to the hashed password.
 */
async function hashPassword(password) {
    try {
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      return hashedPassword;
    } catch (error) {
      throw error;
    }
}

module.exports = {
  hashPassword,
};
