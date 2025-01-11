const app = require('./app');
const db = require('./config/db');
const UserModel = require('./model/user.model');
const PropertyModel = require("./model/property.model")

const port = 3000;

app.get('/',(req,res)=>{
    console.log("Hi this is RentEase fyp!!")
});

app.listen(port,() => {
    console.log(`Server listening on port http://localhost:${port}`);
});