const express = require('express');
const body_parser = require('body-parser');
const cors = require('cors');
const multer = require('multer');  // Import multer
const userRouter = require('./routes/user.router');
const propertyRouter = require('./routes/property.router');
const tenantRouter = require('./routes/tenant.router');
const rentRouter = require('./routes/rent.router');

const app = express();

// Configure multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');  // Set the destination folder for uploaded files
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);  // Rename the file to avoid overwriting
  },
});

const upload = multer({ 
  storage: storage, 
  limits: { fileSize: 50 * 1024 * 1024 } // Set file size limit (50MB here)
});

// Use middlewares
app.use(cors());
app.use(body_parser.json());

// Routes
app.use('/', userRouter);
app.use('/property', propertyRouter);
app.use('/tenant', tenantRouter);
app.use('/rent', rentRouter);

module.exports = app;
