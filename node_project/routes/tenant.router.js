const express = require('express');
const TenantController = require('../controller/tenant.controller');
const router = express.Router();

router.post('/saveTenant', TenantController.saveTenant);

module.exports = router;
