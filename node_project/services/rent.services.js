const Rent = require('./rent.model');

exports.createRent = async (data) => {
  const rent = new Rent(data);
  return await rent.save();
};

module.exports = RentServices;