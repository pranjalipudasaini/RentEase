const Rent = require('../model/rent.model');

class RentServices {
  static async createRent(RentData) {
    try {
      const rent = new Rent(RentData);
        
        const savedRent = await rent.save();
        
        return savedRent;
    } catch (error) {
        throw new Error('Error saving Rent: ' + error.message);
    }
}
}

module.exports = RentServices;