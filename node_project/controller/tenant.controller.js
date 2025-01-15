const TenantServices = require('../services/tenant.services');
const UserService = require('../services/user.services');
const jwt = require('jsonwebtoken');

exports.saveTenant = async (req, res) => {
  try {
    const tenantData = req.body;
    
    // Extract token from Authorization header
    const token = req.headers.authorization?.split(" ")[1]; // "Bearer token_value"
    
    if (!token) {
      throw new Error('Authorization token is missing');
    }

    // Decode the token to get email
    const decodedToken = jwt.verify(token, 'secretKey');
    
    // Get user by email from decoded token
    const user = await UserService.findUserByEmail(decodedToken.email);
    if (!user) {
      throw new Error('User not found');
    }

    // Create the tenant
    const tenant = await TenantServices.createTenant(tenantData);

    // Generate a new token for the user (optional, you may already have the token)
    const tokenData = { _id: user._id, email: user.email, role: user.role };
    const newToken = await UserService.generateToken(tokenData, 'secretKey', '1h');
    if (!newToken) {
      throw new Error('Failed to generate token');
    }

    res.status(201).json({
      success: true,
      message: 'Tenant saved successfully',
      tenant,
      token: newToken, // Send back the new token if needed
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
