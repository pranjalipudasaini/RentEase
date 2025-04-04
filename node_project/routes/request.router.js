const express = require('express');
const router = express.Router();
const requestController = require('../controller/request.controller');
const multer = require('multer');

// Storage configuration for uploaded files
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/'); // Specify where to store the uploaded images
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname); // Unique filename
  },
});

const upload = multer({ storage: storage });

// Route to create maintenance requests (ensure the path matches your Postman request)
router.post('/createRequest', upload.single('image'), (req, res, next) => {
    console.log("Request made to /request/createRequest");
    next(); // Call the next middleware (controller)
}, requestController.createRequest);

module.exports = router;
