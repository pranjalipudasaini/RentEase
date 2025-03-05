const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const ApplicationSchema = new mongoose.Schema({
    fullName: { type: String, required: true },
    dob: { type: String, required: true },
    email: { type: String, required: true },
    contactNumber: { type: String, required: true },
    employmentStatus: { type: String, required: true },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property', required: true },
    landlordEmail: { type: String, required: true },
    createdAt: { type: Date, default: Date.now }
});

const ApplicationModel = db.model('Application', ApplicationSchema);
module.exports = ApplicationModel;
