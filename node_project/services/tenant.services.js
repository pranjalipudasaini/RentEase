const Tenant = require('./tenant.model');

exports.createTenant = async (data) => {
  const tenant = new Tenant(data);
  return await tenant.save();
};

module.exports = TenantServices;