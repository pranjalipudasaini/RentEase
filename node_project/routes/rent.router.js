const express = require('express');
const RentController = require('../controller/rent.controller');
const router = express.Router();

router.post('/saveRent', RentController.saveRent);

module.exports = router;

