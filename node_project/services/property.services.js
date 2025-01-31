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

    static async getPropertyData(userId) {
            const propertyData = await PropertyModel.find({userId});            
            return propertyData;
    }

    static async deleteProperty(propertyId) {
        try {
            const deletedProperty = await PropertyModel.findByIdAndDelete(propertyId);
            return deletedProperty;
        } catch (error) {
            throw new Error("Error deleting property: " + error.message);
        }
    }    
}

module.exports = PropertyServices;
