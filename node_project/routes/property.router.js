const express = require('express');
const PropertyController = require('../controller/property.controller'); 
const router = express.Router();

router.post('/saveProperty', PropertyController.createPropertyHandler);  
router.get("/getProperty", PropertyController.getPropertyData); 
router.delete("/deleteProperty/:id", PropertyController.deletePropertyHandler);
router.put("/updateProperty/:id", PropertyController.updatePropertyHandler);
router.patch("/toggleAvailability/:id", PropertyController.toggle_availability);
router.get("/availableProperties", PropertyController.getAvailableProperties);

module.exports = router;
