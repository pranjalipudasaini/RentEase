const express = require('express');
const body_parser = require('body-parser');
const cors = require('cors');
const userRouter = require('./routes/user.router');
const propertyRouter = require('./routes/property.router');
const tenantRouter = require('./routes/tenant.router');
const rentRouter = require('./routes/rent.router');

const app = express();

app.use(cors());
app.use(body_parser.json());

// Routes
app.use('/', userRouter);
app.use('/property', propertyRouter);
app.use('/tenant',tenantRouter);
app.use('/rent',rentRouter);

module.exports = app;
