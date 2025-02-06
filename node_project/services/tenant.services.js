const TenantModel = require('../model/tenant.model');
const Tenant = require('../model/tenant.model');

class TenantServices {
  static async createTenant(tenantData) {
    try {
      const tenant = new Tenant(tenantData);
        
        const savedTenant = await tenant.save();
        
        return savedTenant;
    } catch (error) {
        throw new Error('Error saving Tenant: ' + error.message);
    }
}

static async getTenantData(userId) {
  const tenantData = await TenantModel.find({userId});            
  return tenantData;
}

static async deleteTenant(tenantId) {
  try {
    const deletedTenant = await TenantModel.findByIdAndDelete(tenantId);
    return deletedTenant;
  } catch (error) {
    throw new Error("Error deleting tenant: " + error.message);
  } 
}

static async updateTenant(tenantId, updateData) {
try {
  const updatedTenant = await TenantModel.findByIdAndUpdate(tenantId, updateData, { new: true });
  return updatedTenant;
} catch (error) {
  throw new Error("Error updating tenant: " + error.message);
}
}

static async getTenantByName(tenantName) {
try {
  const tenant = await TenantModel.findOne({ tenantName });
  return tenant;
} catch (error) {
  throw new Error("Error checking tenant name: " + error.message);
}
}

static async getTenantByEmail(email) {
  try {
    return await Tenant.findOne({ email });
  } catch (error) {
    throw new Error("Error checking tenant by email: " + error.message);
  }
}


}

module.exports = TenantServices;