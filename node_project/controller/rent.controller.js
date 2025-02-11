const RentServices = require('../services/rent.services');
const UserService = require('../services/user.services');
const jwt = require('jsonwebtoken');

class RentController {

    static async saveRent(req, res) {
        try {
            console.log("Received rent data:", req.body);
          const rentData = req.body;
      
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
      
          // Add userId to rent data before saving
          rentData.userId = user._id;
      
          // Create the rent with the userId attached
          const rent = await RentServices.createRent(rentData);
      
          // Generate a new token for the user (optional, you may already have the token)
          const tokenData = { _id: user._id, email: user.email, role: user.role };
          const newToken = await UserService.generateToken(tokenData, 'secretKey', '1h');
          if (!newToken) {
            throw new Error('Failed to generate token');
          }
      
          res.status(201).json({
            success: true,
            message: 'Rent saved successfully',
            rent,
            token: newToken, // Send back the new token if needed
          });
        } catch (error) {
          res.status(400).json({ error: error.message });
        }
      }
      

      // Get Rent Data
  static async getRentData(req, res, next) {
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

        const rents = await RentServices.getRentData(userId);
        
        res.json({ status: true, success: rents });
    } catch (error) {
        console.error("Error during token verification:", error); // Added logging
        next(error);
    }
}
      
// Delete Rent Handler
static async deleteRentHandler(req, res) {
    try {
        const rentId = req.params.id;  // Ensure the ID is extracted correctly
        console.log("Received Rent ID for deletion:", rentId); // Debugging log

        if (!rentId) {
            return res.status(400).json({ success: false, message: "Rent ID is required" });
        }

        const deletedRent = await RentServices.deleteRent(rentId);

        if (!deletedRent) {
            return res.status(404).json({ success: false, message: "Rent not found" });
        }

        res.json({ success: true, message: "Rent deleted successfully" });
    } catch (error) {
        res.status(500).json({ success: false, message: "Error deleting Rent: " + error.message });
    }
}

// Update Rent Handler
static async updateRentHandler(req, res) {
    try {
        const rentId = req.params.id;
        const updateData = req.body;

        // Check for duplicate Rent name during update
        if (updateData.rentName) {
            // Check if the rent name already exists in other properties (excluding the current rent)
            const existingRent = await RentServices.getRentByName(updateData.rentName);
            if (existingRent && existingRent._id !== rentId) {
                return res.status(400).json({ success: false, message: "Rent name already exists" });
            }
        }

        if (!rentId) {
            return res.status(400).json({ success: false, message: "Rent ID is required" });
        }

        const updatedRent = await RentServices.updateRent(rentId, updateData);

        if (!updatedRent) {
            return res.status(404).json({ success: false, message: "Rent not found" });
        }

        res.json({
            success: true,
            message: "Rent updated successfully",
            rent: updatedRent,
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Error updating rent: " + error.message });
    }
}
}

module.exports = RentController;


