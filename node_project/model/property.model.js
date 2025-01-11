const db = require('../config/db');
const mongoose = require('mongoose');
const UserModel = require("../model/user.model");
const { Schema } = mongoose;

const propertySchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: UserModel.modelName },
    propertyName: { type: String, required: true },
    address: { type: String, required: true },
    country: { type: String, default: 'Nepal', required: true },
    city: {
        type: String,
        required: true,
        enum: ['Kathmandu', 'Pokhara', 'Biratnagar', 'Bhaktapur', 'Lalitpur', 'Dharan', 'Birgunj'],
    },
    furnishing: { type: String, enum: ['Furnished', 'Unfurnished'] },
    size: { type: Number },
    specifications: {
        bathrooms: { type: Number, default: 0 },
        kitchens: { type: Number, default: 0 },
        bedrooms: { type: Number, default: 0 },
        livingRooms: { type: Number, default: 0 },
        roadType: { type: String },
    },
    amenities: {
        type: [String],
        enum: ['Parking', 'WiFi', 'In-unit Washer', 'Garden', 'Swimming Pool', 'Gym'],
    },
});

const propertyModel = db.model('property', propertySchema);

module.exports = propertyModel;
