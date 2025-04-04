require('dotenv').config();

const express = require('express');
const body_parser = require('body-parser');
const cors = require('cors');
const path = require('path');

const userRouter = require('./routes/user.router');
const propertyRouter = require('./routes/property.router');
const tenantRouter = require('./routes/tenant.router');
const rentRouter = require('./routes/rent.router');
const applicationRouter = require('./routes/application.router');
const requestRouter = require('./routes/request.router');

const app = express();

// Middleware
app.use(cors());
app.use(body_parser.json());  // Ensures JSON data is parsed

// Serve uploaded images (make sure your 'uploads' folder exists and has the right permissions)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/', userRouter);
app.use('/property', propertyRouter);
app.use('/tenant', tenantRouter);
app.use('/rent', rentRouter);
app.use('/application', applicationRouter);
app.use('/request', requestRouter);  // Ensure this is the correct route for maintenance requests

// Add a simple route for debugging purposes
app.get('/', (req, res) => {
    res.send('Server is running');
});

module.exports = app;
