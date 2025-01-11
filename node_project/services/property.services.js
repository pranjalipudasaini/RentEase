const PropertyModel = require("../model/property.model");

class PropertyServices {
    static async createProperty(propertyData) {
        try {
            const newProperty = new PropertyModel(propertyData);
            
            const savedProperty = await newProperty.save();
            
            return savedProperty;
        } catch (error) {
            throw new Error('Error creating property: ' + error.message);
        }
    }
}

module.exports = PropertyServices;
