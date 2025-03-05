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
        const propertyData = await PropertyModel.find({ userId });
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
            const property = await PropertyModel.findOne({ propertyName });
            return property;
        } catch (error) {
            throw new Error("Error checking property name: " + error.message);
        }
    }

    static async toggleAvailability(propertyId) {
        try {
            const property = await PropertyModel.findById(propertyId);
            if (!property) throw new Error("Property not found");
    
            property.isAvailable = !property.isAvailable;
            await property.save();
            
            return { message: "Property availability updated", isAvailable: property.isAvailable, property };
        } catch (error) {
            throw new Error("Error toggling property availability: " + error.message);
        }
    }

    static async getAvailableProperties() {
        try {
            const properties = await PropertyModel.find({ isAvailable: true });
            return properties;
        } catch (error) {
            throw new Error("Error fetching available properties: " + error.message);
        }
    }   
}

module.exports = PropertyServices;
