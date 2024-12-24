const mongoose = require('mongoose');

const connection = mongoose.createConnection('mongodb://localhost:27017/RentEaseNew').on('open',()=>{
    console.log("Mongodb Connection Successful!!");
}).on('error',()=>{
    console.log("Mongodb Connection Error");
});

module.exports = connection;