const Tenant = require('../model/tenant.model');

exports.saveTenant = async (req, res) => {
  try {
    const tenant = new Tenant(req.body);
    await tenant.save();
    res.status(201).json({ message: 'Tenant saved successfully', tenant });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

