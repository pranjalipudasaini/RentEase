const express = require('express');
const router = express.Router();
const { submitApplication, getApplicationData, getLandlordApplications, updateApplicationStatus } = require('../controller/application.controller');

router.post('/submit', submitApplication);
router.get('/getApplication', getApplicationData); 
router.get('/getLandlordApplications', getLandlordApplications);
router.put('/updateStatus', updateApplicationStatus);

module.exports = router;
