const PropertyServices = require("../services/property.services");
const UserService = require("../services/user.services");
const jwt = require("jsonwebtoken");

class PropertyController {
    // Create Property
    static async createPropertyHandler(req, res) {
        try {
            console.log("Headers received:", req.headers); // Debugging
        
            const authHeader = req.headers.authorization;
            if (!authHeader) {
                return res.status(401).json({ success: false, message: "Authorization header is missing" });
            }
        
            const token = authHeader.split(" ")[1];
            if (!token) {
                return res.status(401).json({ success: false, message: "Authorization token is missing" });
            }
        
            console.log("Extracted Token:", token); // Debugging
        
            const decodedToken = jwt.verify(token, "secretKey");
            console.log("Decoded Token:", decodedToken);
        
            const userId = decodedToken._id;
            if (!userId) {
                return res.status(401).json({ success: false, message: "Invalid token: user ID is missing" });
            }
        
            const { propertyName, address, country, city, furnishing, size, specifications, amenities } = req.body;
    
            // Validate required fields
            if (!propertyName) {
                return res.status(400).json({ success: false, message: "Property name is required" });
            }
            if (!address) {
                return res.status(400).json({ success: false, message: "Address is required" });
            }
            if (!city) {
                return res.status(400).json({ success: false, message: "City is required" });
            }
        
            // Optional validation for city
            const validCities = ['Kathmandu', 'Pokhara', 'Biratnagar', 'Bhaktapur', 'Lalitpur', 'Dharan', 'Birgunj'];
            if (!validCities.includes(city)) {
                return res.status(400).json({ success: false, message: "Invalid city selected" });
            }
    
            // Check if property name already exists
            const existingProperty = await PropertyServices.getPropertyByName(propertyName);
            if (existingProperty) {
                return res.status(400).json({ success: false, message: "A property with this name already exists" });
            }
        
            const propertyData = {
                userId,
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
            console.error("Error creating property:", error); // Debugging
            res.status(400).json({ success: false, message: error.message });
        }
    }
    

    // Get Property Data
    static async getPropertyData(req, res, next) {
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
    
            const properties = await PropertyServices.getPropertyData(userId);
            res.json({ status: true, success: properties });
        } catch (error) {
            console.error("Error during token verification:", error); // Added logging
            next(error);
        }
    }

    // Delete Property Handler
    static async deletePropertyHandler(req, res) {
        try {
            const propertyId = req.params.id;  // Ensure the ID is extracted correctly
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

    // Update Property Handler
    static async updatePropertyHandler(req, res) {
        try {
            const propertyId = req.params.id;
            const updateData = req.body;

            // Check for duplicate property name during update
            if (updateData.propertyName) {
                // Check if the property name already exists in other properties (excluding the current property)
                const existingProperty = await PropertyServices.getPropertyByName(updateData.propertyName);
                if (existingProperty && existingProperty._id !== propertyId) {
                    return res.status(400).json({ success: false, message: "Property name already exists" });
                }
            }
    
            if (!propertyId) {
                return res.status(400).json({ success: false, message: "Property ID is required" });
            }
    
            const updatedProperty = await PropertyServices.updateProperty(propertyId, updateData);
    
            if (!updatedProperty) {
                return res.status(404).json({ success: false, message: "Property not found" });
            }
    
            res.json({
                success: true,
                message: "Property updated successfully",
                property: updatedProperty,
            });
        } catch (error) {
            res.status(500).json({ success: false, message: "Error updating property: " + error.message });
        }
    }

    static async toggle_availability(req, res) {
        try {
            const result = await PropertyServices.toggleAvailability(req.params.id);
            res.json(result);
        } catch (error) {
            res.status(500).json({ message: 'Server error', error: error.message });
        }
    }
    
}

module.exports = PropertyController;
