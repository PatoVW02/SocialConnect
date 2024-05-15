const mongoose = require("mongoose");

const Address = {
    street1: String,
    street2: String,
    city: String,
    state: String,
    zipCode: String,
    country: String
}

const Contact = {
    phoneNumber: String,
    email: String
}

const SocialNetwork = {
    name: String,
    url: String,
    _id: false
}

const organizationSchema = new mongoose.Schema({
    id: mongoose.Schema.Types.ObjectId,
    userId: mongoose.Schema.Types.ObjectId,
    name: String,
    userName: String,
    address: Address,
    contact: Contact,
    description: String,
    rfc: String,
    schedule: String,
    socialNetworks: [SocialNetwork],
    logoUrl: String,
    videoUrl: String,
    bannerUrl: String,
    tags: [mongoose.Schema.Types.ObjectId],
    createdAt: Date,
    updatedAt: Date
});

const Organization = mongoose.model(
  "Organization",
  organizationSchema,
  "organizations"
);

module.exports = Organization;
