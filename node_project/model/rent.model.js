const db = require('../config/db');
const mongoose = require('mongoose');

const rentSchema = new mongoose.Schema({
    dueDate: { type: Date, required: true },
    otherCharges: { type: Number },
    lateFeeCharges: {
      days: { type: Number },
      amount: { type: Number },
    },
    recurringDay: { type: String, enum: ['1st', '2nd', '3rd', '4th', '5th'], required: true },
});


const rentModel = db.model('rent', rentSchema);

module.exports = rentModel;


