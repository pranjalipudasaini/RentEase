const express = require('express');
const TenantController = require('../controller/tenant.controller');
const router = express.Router();

router.post('/saveTenant', TenantController.saveTenant);
router.get("/getTenant", TenantController.getTenantData); 
router.delete("/deleteTenant/:id", TenantController.deleteTenantHandler);
router.put("/updateTenant/:id", TenantController.updateTenantHandler);

module.exports = router;
