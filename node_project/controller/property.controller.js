const PropertyServices = require("../services/property.services");
const UserService = require("../services/user.services");
const jwt = require("jsonwebtoken");

class PropertyController {
    // Create Property
    static async createPropertyHandler(req, res) {
        try {
            const { propertyName, address, country, city, furnishing, size, specifications, amenities } = req.body;

            // Extract token from Authorization header
            const token = req.headers.authorization?.split(" ")[1]; // "Bearer token_value"
            if (!token) {
                throw new Error("Authorization token is missing");
            }

            // Decode the token to get user details
            const decodedToken = jwt.verify(token, "secretKey");
            const userId = decodedToken._id; // Extract user ID from token

            if (!userId) {
                throw new Error("Invalid token: user ID is missing");
            }

            // Create the property with the user ID
            const propertyData = {
                userId, // Pass the valid ObjectId here
                propertyName,
                address,
                country,
                city,
                furnishing,
                size,
                specifications,
                amenities,
            };

            const createdProperty = await PropertyServices.createProperty(propertyData);

            res.status(201).json({
                success: true,
                property: createdProperty,
            });
        } catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }

    // Get Property Data
    static async getPropertyData(req, res, next) {
        try {
            // Extract token from Authorization header
            const token = req.headers.authorization?.split(" ")[1]; 
            if (!token) {
                throw new Error("Authorization token is missing");
            }
    
            // Decode the token to get user details
            const decodedToken = jwt.verify(token, "secretKey");
            const userId = decodedToken._id; 
    
            if (!userId) {
                throw new Error("Invalid token: user ID is missing");
            }
    
            // Fetch property data by userId
            const properties = await PropertyServices.getPropertyData(userId);
    
            res.json({ status: true, success: properties });
        } catch (error) {
            next(error); 
        }
    }
    

    static async deletePropertyHandler(req, res) {
        try {
            const propertyId = req.params.id;  // <-- Ensure the ID is extracted correctly
    
            console.log("Received Property ID for deletion:", propertyId); // Debugging log
    
            if (!propertyId) {
                return res.status(400).json({ success: false, message: "Property ID is required" });
            }
    
            const deletedProperty = await PropertyServices.deleteProperty(propertyId);
    
            if (!deletedProperty) {
                return res.status(404).json({ success: false, message: "Property not found" });
            }
    
            res.json({ success: true, message: "Property deleted successfully" });
        } catch (error) {
            res.status(500).json({ success: false, message: "Error deleting property: " + error.message });
        }
    }
    
}    

module.exports = PropertyController;
