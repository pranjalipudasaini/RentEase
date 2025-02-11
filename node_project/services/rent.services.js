const RentModel = require('../model/rent.model'); 

class RentServices {
  static async createRent(RentData) {
    try {
      const rent = new RentModel(RentData);
        
        const savedRent = await rent.save();
        
        return savedRent;
    } catch (error) {
        throw new Error('Error saving Rent: ' + error.message);
    }
}

static async getRentData(userId) {
  const rentData = await RentModel.find({userId});            
  return rentData;
}

static async deleteRent(rentId) {
try {
  const deletedrent = await RentModel.findByIdAndDelete(rentId);
  return deletedrent;
} catch (error) {
  throw new Error("Error deleting rent: " + error.message);
}
}  

static async updateRent(rentId, updateData) {
try {
  const updatedRent = await RentModel.findByIdAndUpdate(rentId, updateData, { new: true });
  return updatedRent;
} catch (error) {
  throw new Error("Error updating rent: " + error.message);
}
}

static async getRentByName(rentName) {
try {
  const rent = await RentModel.findOne({ rentName });
  return rent;
} catch (error) {
  throw new Error("Error checking rent name: " + error.message);
}
}
}

module.exports = RentServices;