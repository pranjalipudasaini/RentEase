const express = require('express');
const router = express.Router();
const { submitApplication } = require('../controller/application.controller');

// Route to submit an application
router.post('/submit', submitApplication);

module.exports = router;
