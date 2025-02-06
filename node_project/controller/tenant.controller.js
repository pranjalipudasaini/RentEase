const TenantServices = require('../services/tenant.services');
const UserService = require('../services/user.services');
const jwt = require('jsonwebtoken');

class TenantController {

  static async saveTenant(req, res) {
    try {
        console.log("Received tenant data:", req.body);
      const tenantData = req.body;
  
      // Extract token from Authorization header
      const token = req.headers.authorization?.split(" ")[1]; // "Bearer token_value"
  
      if (!token) {
        throw new Error('Authorization token is missing');
      }
      const decodedToken = jwt.verify(token, 'secretKey');
      
      const user = await UserService.findUserByEmail(decodedToken.email);
      if (!user) {
        throw new Error('User not found');
      }
  
      // Add userId to tenant data before saving
      tenantData.userId = user._id;
  
      // Create the tenant with the userId attached
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
  }
  

  // Get Tenant Data
  static async getTenantData(req, res, next) {
    try {
        console.log("Headers received:", req.headers); // Debugging

        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return res.status(401).json({ success: false, message: "Authorization header is missing" });
        }

        const token = authHeader.split(" ")[1]; // Get token part after "Bearer"
        if (!token) {
            return res.status(401).json({ success: false, message: "Authorization token is missing" });
        }

        console.log("Extracted Token:", token); // Debugging

        const decodedToken = jwt.verify(token, "secretKey");
        console.log("Decoded Token:", decodedToken); // Debugging

        const userId = decodedToken._id;
        if (!userId) {
            return res.status(401).json({ success: false, message: "Invalid token: user ID is missing" });
        }

        const tenants = await TenantServices.getTenantData(userId);
        
        res.json({ status: true, success: tenants });
    } catch (error) {
        console.error("Error during token verification:", error); // Added logging
        next(error);
    }
}

// Delete Tenant Handler
static async deleteTenantHandler(req, res) {
    try {
        const tenantId = req.params.id;  // Ensure the ID is extracted correctly
        console.log("Received Tenant ID for deletion:", tenantId); // Debugging log

        if (!tenantId) {
            return res.status(400).json({ success: false, message: "Tenant ID is required" });
        }

        const deletedTenant = await TenantServices.deleteTenant(tenantId);

        if (!deletedTenant) {
            return res.status(404).json({ success: false, message: "Tenant not found" });
        }

        res.json({ success: true, message: "Tenant deleted successfully" });
    } catch (error) {
        res.status(500).json({ success: false, message: "Error deleting Tenant: " + error.message });
    }
}

static async updateTenantHandler(req, res) {
    try {
        const tenantId = req.params.id;
        const updateData = req.body;
 
        console.log("Received update request for Tenant ID:", tenantId);  // Log tenantId
        console.log("Update Data:", updateData);  // Log updated data
 
        // Validation checks
        if (!tenantId) {
            return res.status(400).json({ success: false, message: "Tenant ID is required" });
        }
 
        const updatedTenant = await TenantServices.updateTenant(tenantId, updateData);
 
        if (!updatedTenant) {
            return res.status(404).json({ success: false, message: "Tenant not found" });
        }
 
        res.json({
            success: true,
            message: "Tenant updated successfully",
            tenant: updatedTenant,
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Error updating tenant: " + error.message });
    }
 }
 
}

module.exports = TenantController;
