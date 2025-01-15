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
}

module.exports = TenantServices;