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
    
    static async updateProperty(propertyId, updateData) {
        try {
            const updatedProperty = await PropertyModel.findByIdAndUpdate(propertyId, updateData, { new: true });
            return updatedProperty;
        } catch (error) {
            throw new Error("Error updating property: " + error.message);
        }
    }

    static async getPropertyByName(propertyName) {
        try {
            // Use PropertyModel instead of Property
            const property = await PropertyModel.findOne({ propertyName });
            return property;
        } catch (error) {
            throw new Error("Error checking property name: " + error.message);
        }
    }
    

    
}

module.exports = PropertyServices;
