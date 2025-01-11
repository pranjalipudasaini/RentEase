const PropertyServices = require("../services/property.services");

class PropertyController {
    static async createPropertyHandler(req, res) {
        try {
            const propertyData = req.body;
            const createdProperty = await PropertyServices.createProperty(propertyData);
            res.status(201).json({ success: true, property: createdProperty });
        } catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
}

module.exports = PropertyController;  // Export the class
