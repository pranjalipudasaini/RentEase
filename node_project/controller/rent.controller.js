const Rent = require('../model/rent.model');

exports.saveRent = async (req, res) => {
  try {
    const rent = new Rent(req.body);
    await rent.save();
    res.status(201).json({ message: 'Rent saved successfully', rent });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};




