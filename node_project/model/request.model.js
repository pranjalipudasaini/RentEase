const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const requestSchema = new Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  priority: { type: String, enum: ['Low', 'Medium', 'High'], default: 'Low' },
  imageUrl: { type: String },
  createdAt: { type: Date, default: Date.now }
});

const RequestModel = db.model('Request', requestSchema);

module.exports = RequestModel;
