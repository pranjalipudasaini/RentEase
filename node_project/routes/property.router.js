const express = require('express');
const PropertyController = require('../controller/property.controller'); // Make sure this is correct
const router = express.Router();

router.post('/saveProperty', PropertyController.createPropertyHandler);  // Ensure PropertyController.createPropertyHandler is defined and imported correctly.

module.exports = router;
