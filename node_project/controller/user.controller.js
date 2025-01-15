const UserService = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        const { fullName, email, password, confirmPassword } = req.body;

        // Validate input fields
        if (!fullName || !email || !password || !confirmPassword) {
            return res.status(400).json({ status: false, error: "All fields are required." });
        }

        // Validate password strength
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$/;
        if (!passwordRegex.test(password) && password.length < 8) {
            return res.status(400).json({
                status: false,
                error: "Password must be at least 8 characters long, contain an uppercase letter, a lowercase letter, a number, and a special character.",
            });
        }
        // Ensure passwords match
        if (password !== confirmPassword) {
            return res.status(400).json({ status: false, error: "Passwords do not match." });
        }

        // Check if user already exists
        const existingUser = await UserService.findUserByEmail(email);
        if (existingUser) {
            return res.status(400).json({ status: false, error: "Email already exists." });
        }

        // Register the user
        const newUser = await UserService.registerUser(fullName, email, password);

        // Prepare token data
        const tokenData = { _id: newUser._id, email: newUser.email, role: "user" }; // Default role is "user"
        const token = await UserService.generateToken(tokenData, "secretKey", '1h');

        return res.status(201).json({
            status: true,
            success: "User registered successfully.",
            token: token, // Include token in response
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            status: false,
            error: "Internal server error. Please try again later.",
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

        let tokenData = { _id: user._id, email: user.email, role: user.role }; // Include the role here

        const token = await UserService.generateToken(tokenData, "secretKey", '1h');

        return res.status(200).json({ 
            status: true, 
            token: token,
            role: user.role // Send the role in the response
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ status: false, error: "Internal server error. Please try again later." });
    }
};

exports.updateRole = async (req, res) => {
    try {
        const { email, role } = req.body;

        if (!email || !role) {
            return res.status(400).json({ status: false, error: "Email and role are required." });
        }

        const user = await UserService.findUserByEmail(email);
        if (!user) {
            return res.status(404).json({ status: false, error: "User not found." });
        }

        user.role = role;
        await user.save();

        // Generate a new token after updating the role
        const tokenData = { _id: user._id, email: user.email, role: user.role };
        const token = await UserService.generateToken(tokenData, "secretKey", '1h');

        res.status(200).json({
            status: true,
            success: "Role updated successfully.",
            token: token,  // Include the token in the response
        });
    } catch (err) {
        res.status(500).json({ status: false, error: "Internal server error." });
    }
};
