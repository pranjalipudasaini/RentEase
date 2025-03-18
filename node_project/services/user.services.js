const UserModel = require('../model/user.model');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');

class UserService {
    // Function to find user by email
    static async findUserByEmail(email) {
        return await UserModel.findOne({ email });
    }

    // Generate OTP (6 digits)
    static generateOTP() {
        return Math.floor(100000 + Math.random() * 900000).toString();
    }

    // Send OTP via email
    static async sendOTPEmail(email, otp) {
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS
            }
        });

        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: email,
            subject: 'Your OTP for Tenant Confirmation',
            text: `Your OTP is ${otp}. It is valid for 10 minutes.`
        };

        return transporter.sendMail(mailOptions);
    }

    // Generate and store OTP for tenant
    static async generateAndSendOTP(email) {
        const user = await UserModel.findOne({ email });

        if (!user) {
            throw new Error("User not found.");
        }

        const otp = this.generateOTP();
        user.otp = otp;
        user.otpExpiresAt = new Date(Date.now() + 10 * 60 * 1000); // OTP valid for 10 minutes
        await user.save();

        await this.sendOTPEmail(email, otp);
        return { message: "OTP sent successfully." };
    }

    // Verify OTP and update role
    static async verifyOTP(email, otp) {
        const user = await UserModel.findOne({ email });

        if (!user || user.otp !== otp || user.otpExpiresAt < new Date()) {
            throw new Error("Invalid or expired OTP.");
        }

        user.role = 'tenant';  // Change role to tenant
        user.otp = null; // Clear OTP
        user.otpExpiresAt = null;
        await user.save();

        return { message: "OTP verified. User role updated to tenant." };
    }

    // Function to register a new user
    static async registerUser(fullName, email, password) {
        try {
            const createUser = new UserModel({ fullName, email, password });
            return await createUser.save();
        } catch (err) {
            throw err;
        }
    }

    // Function to find a user by email
    static async findUserByEmail(email) {
        try {
            return await UserModel.findOne({ email }); // Finds user by email
        } catch (err) {
            throw err;
        }
    }

    static async generateToken(tokenData,secretKey,jwt_expire){
        return jwt.sign(tokenData,secretKey,{expiresIn:jwt_expire});
    }
}

module.exports = UserService;