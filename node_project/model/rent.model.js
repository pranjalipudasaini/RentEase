const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const rentSchema = new mongoose.Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    dueDate: { type: Date, required: true },
    otherCharges: { type: Number },
    lateFeeCharges: {
      days: { type: Number },
      amount: { type: Number },
    },
    recurringDay: { type: String, enum: ['1st', '2nd', '3rd', '4th', '5th'], required: true },
    tenantId: { type: Schema.Types.ObjectId, ref: 'Tenant', required: true } 
});


const RentModel = db.model('Rent', rentSchema);

module.exports = RentModel;


