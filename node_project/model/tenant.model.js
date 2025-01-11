const db = require('../config/db');
const mongoose = require('mongoose');

const tenantSchema = new mongoose.Schema({
  tenantName: { type: String, required: true },
  tenantEmail: { type: String, required: true },
  tenantContactNumber: { type: String, required: true },
  leaseStartDate: { type: Date, required: true },
  leaseEndDate: { type: Date, required: true },
  rentAmount: { type: Number, required: true },
});


const tenantModel = db.model('tenant', tenantSchema);

module.exports = tenantModel;


