const UserModel = require('../model/user.model');
const jwt = require('jsonwebtoken');

class UserService {
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