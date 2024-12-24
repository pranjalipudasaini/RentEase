const express = require('express');
const body_parser = require('body-parser');
const cors = require('cors'); 
const userRouter = require('./routes/user.router');

const app = express();

app.use(cors());  

app.use(body_parser.json());

// Routes
app.use('/', userRouter);

module.exports = app;
