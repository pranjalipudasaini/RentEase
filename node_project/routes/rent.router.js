const express = require('express');
const RentController = require('../controller/rent.controller');
const router = express.Router();

router.post('/saveRent', RentController.saveRent);
router.get("/getRent", RentController.getRentData); 
router.delete("/deleteRent/:id", RentController.deleteRentHandler);
router.put("/updateRent/:id", RentController.updateRentHandler);

module.exports = router;

