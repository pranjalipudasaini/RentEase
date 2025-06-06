const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const propertySchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true }, 
    userEmail: { type: String, ref: 'User', required: true, index: true }, 
    userName: { type: String, ref: 'User', required: true, index: true }, 
    propertyName: { type: String, required: true },
    address: { type: String, required: true },
    country: { type: String, default: 'Nepal', required: true },
    city: {
        type: String,
        required: true,
        enum: ['Kathmandu', 'Pokhara', 'Biratnagar', 'Bhaktapur', 'Lalitpur', 'Dharan', 'Birgunj'],
        default: 'Kathmandu',
    },
    furnishing: { type: String, enum: ['Furnished', 'Unfurnished', 'Semi-Furnished'], default: 'Furnished' },
    roadType: { type: String, default: 'Paved' }, 
    type: { 
        type: String,
        required: true,
        enum: ['Apartment', 'House', 'Condo', 'Land'],
        default: 'Apartment',
    },
    size: { type: Number, default: 0 }, 
    specifications: {
        type: new Schema({
            bathrooms: { type: Number, default: 0 },
            kitchens: { type: Number, default: 0 },
            bedrooms: { type: Number, default: 0 },
            livingRooms: { type: Number, default: 0 },
        }, { _id: false }), 
        default: {} 
    },
    amenities: {
        type: [String],
        validate: {
            validator: function (value) {
                const allowedAmenities = ['Parking', 'WiFi', 'In-unit Washer', 'Garden', 'Swimming Pool', 'Gym'];
                return value.every((amenity) => allowedAmenities.includes(amenity));
            },
            message: 'Invalid amenity value!',
        },
    },
    images: { type: String, default: '' }, 
    isAvailable: { type: Boolean, default: true },
}, { timestamps: true });

const PropertyModel = db.model('Property', propertySchema);
module.exports = PropertyModel;
