const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const ApplicationSchema = new Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // Applicant ID
    landlordId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // New: Landlord ID
    fullName: { type: String, required: true },
    dob: { type: String, required: true },
    email: { type: String, required: true },
    contactNumber: { type: String, required: true },
    currentAddress: { type: String },
    employmentStatus: { type: String, required: true },
    employerName: { type: String },
    jobTitle: { type: String },
    income: { type: String, required: true },
    landlordName: { type: String },
    tenancyDuration: { type: String },
    reasonLeaving: { type: String },
    status: { type: String, enum: ['Pending', 'Approved', 'Declined'], default: 'Pending' },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property', required: true },
    landlordEmail: { type: String, required: true },
    createdAt: { type: Date, default: Date.now }
});


const ApplicationModel = db.model('Application', ApplicationSchema);
module.exports = ApplicationModel;
