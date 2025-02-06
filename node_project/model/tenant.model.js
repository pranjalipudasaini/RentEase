const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const tenantSchema = new mongoose.Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  tenantName: { type: String, required: true },
  tenantEmail: { type: String, required: true },
  tenantContactNumber: { type: String, required: true },
  leaseStartDate: { type: Date, required: true },
  leaseEndDate: { type: Date, required: true },
  rentAmount: { type: Number, required: true },
  propertyId: { type: Schema.Types.ObjectId, ref: 'Property', required: true } // Added propertyId field
});

const TenantModel = db.model('Tenant', tenantSchema);

module.exports = TenantModel;
