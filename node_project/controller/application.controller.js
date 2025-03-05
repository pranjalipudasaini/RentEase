const Application = require('../model/application.model');
const Property = require('../model/property.model'); // Import Property model
const nodemailer = require('nodemailer');

// Configure email transporter
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER, // Your email
        pass: process.env.EMAIL_PASS  // Your email password or app password
    }
});

const sendApplicationEmail = async (application) => {
    console.log("Landlord Email:", application.landlordEmail);  
    
    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: application.landlordEmail,
        subject: 'New Rental Application',
        text: `
            A new rental application has been submitted.

            Full Name: ${application.fullName}
            Date of Birth: ${application.dob}
            Email: ${application.email}
            Contact Number: ${application.contactNumber}
            Employment Status: ${application.employmentStatus}

            Please review the application.
        `
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log("Application email sent successfully.");
    } catch (error) {
        console.error("Error sending email:", error);
    }
};


// Controller to handle application submission
const submitApplication = async (req, res) => {
    try {
        const { fullName, dob, email, contactNumber, employmentStatus, propertyId } = req.body;

        // Fetch the property to get the landlord's email (userEmail)
        const property = await Property.findById(propertyId);
        
        if (!property) {
            return res.status(404).json({ message: "Property not found" });
        }

        const landlordEmail = property.userEmail; 
        
        if (!landlordEmail) {
            return res.status(400).json({ message: "Landlord email not found in property" });
        }

        // Create a new application object
        const application = new Application({
            fullName,
            dob,
            email,
            contactNumber,
            employmentStatus,
            propertyId,
            landlordEmail  // Use the fetched landlord email
        });

        // Save the application to the database
        await application.save();

        // Send email to the landlord
        await sendApplicationEmail(application);

        // Respond with a success message
        res.status(201).json({ message: "Application submitted successfully", application });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error", details: error.message });
    }
};

module.exports = { submitApplication };
