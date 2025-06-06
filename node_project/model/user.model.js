const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require("bcrypt");

const { Schema } = mongoose;

const userSchema = new Schema({
    fullName: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    role: {
        type: String,
        enum: ['tenant', 'landlord', 'tenant_planned'],
        default: 'tenant'
    },
    otp: { 
        type: String 
    }, 
    otpExpiresAt: { 
        type: Date 
    },
});



// Hash password before saving
userSchema.pre('save', async function () {
    try {
        const user = this;
        if (user.isModified("password")) { // Hash only if password is modified or new
            const salt = await bcrypt.genSalt(10);
            const hashpass = await bcrypt.hash(user.password, salt);
            user.password = hashpass;
        }
    } catch (error) {
        throw error;
    }
});

userSchema.methods.comparePassword = async function(userPassword){
    try{
        const isMatch = await bcrypt.compare(userPassword,this.password);
        return isMatch;
    }catch(error){
        throw error;
    }
}

const userModel = db.model('user', userSchema);

module.exports = userModel;