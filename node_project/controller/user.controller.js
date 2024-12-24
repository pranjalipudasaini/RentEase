const UserService = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        const { fullName, email, password, confirmPassword } = req.body;

        if (!fullName || !email || !password || !confirmPassword) {
            return res.status(400).json({ status: false, error: "All fields are required." });
        }

        if (password !== confirmPassword) {
            return res.status(400).json({ status: false, error: "Passwords do not match." });
        }

        const existingUser = await UserService.findUserByEmail(email);
        if (existingUser) {
            return res.status(400).json({ status: false, error: "Email already exists." });
        }

        const successRes = await UserService.registerUser(fullName, email, password);
        
        return res.status(201).json({
            status: true,
            success: "User registered successfully."
        });
        
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: false,
            error: "Internal server error. Please try again later."
        });
    }
};

exports.login = async (req, res, next) => {
    console.log('Login request received:', req.body);
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ status: false, error: "Email and password are required." });
        }

        const user = await UserService.findUserByEmail(email);

        if (!user) {
            return res.status(404).json({ status: false, error: "User not found." });
        }

        const isMatch = await user.comparePassword(password);

        if (!isMatch) {
            return res.status(401).json({ status: false, error: "Invalid password." });
        }

        let tokenData = { _id: user._id, email: user.email };

        const token = await UserService.generateToken(tokenData, "secretKey", '1h');

        return res.status(200).json({ status: true, token: token });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ status: false, error: "Internal server error. Please try again later." });
    }
};
