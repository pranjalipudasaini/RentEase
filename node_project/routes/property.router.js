const express = require('express');
const PropertyController = require('../controller/property.controller'); 
const router = express.Router();

router.post('/saveProperty', PropertyController.createPropertyHandler);  
router.get("/getProperty", PropertyController.getPropertyData); 
router.delete("/deleteProperty/:id", PropertyController.deletePropertyHandler);


module.exports = router;
