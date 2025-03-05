const Application = require('../model/application.model');
const Property = require('../model/property.model'); 
const ApplicationServices = require("../services/application.services");
const jwt = require("jsonwebtoken");
const nodemailer = require('nodemailer');

// Configure email transporter
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS  
    }
});

// Function to send email
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
            Current Address: ${application.currentAddress}
            Employment Status: ${application.employmentStatus}
            Employer: ${application.employerName}
            Job Title: ${application.jobTitle}
            Income: ${application.income}
            Previous Landlord: ${application.landlordName}
            Tenancy Duration: ${application.tenancyDuration}
            Reason for Leaving: ${application.reasonLeaving}

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

const submitApplication = async (req, res) => {
    try {
        const { 
            fullName, dob, email, contactNumber, currentAddress, employmentStatus, 
            employerName, jobTitle, income, landlordName, tenancyDuration, reasonLeaving, propertyId 
        } = req.body;

        const authHeader = req.headers.authorization;
        if (!authHeader) return res.status(401).json({ message: "Authorization header is missing" });

        const token = authHeader.split(" ")[1];
        if (!token) return res.status(401).json({ message: "Authorization token is missing" });

        const decodedToken = jwt.verify(token, "secretKey");
        const userId = decodedToken._id;

        if (!userId) return res.status(401).json({ message: "Invalid token: user ID is missing" });

        // Fetch property details to get landlord info
        const property = await Property.findById(propertyId);
        if (!property) return res.status(404).json({ message: "Property not found" });

        const landlordEmail = property.userEmail;
        const landlordId = property.userId; // Assuming property stores landlord's userId

        if (!landlordEmail || !landlordId) {
            return res.status(400).json({ message: "Landlord details missing in property" });
        }

        // Create new application with landlordId
        const application = new Application({
            userId, 
            landlordId, // Store landlord's ID separately
            fullName, dob, email, contactNumber, currentAddress, 
            employmentStatus, employerName, jobTitle, income, 
            landlordName, tenancyDuration, reasonLeaving, propertyId, landlordEmail
        });

        await application.save();
        await sendApplicationEmail(application);

        res.status(201).json({ message: "Application submitted successfully", application });
    } catch (error) {
        console.error("Error during application submission:", error);
        res.status(500).json({ error: "Internal Server Error", details: error.message });
    }
};

const getLandlordApplications = async (req, res) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return res.status(401).json({ success: false, message: "Authorization header is missing" });
        }

        const token = authHeader.split(" ")[1];
        if (!token) {
            return res.status(401).json({ success: false, message: "Authorization token is missing" });
        }

        const decodedToken = jwt.verify(token, "secretKey");
        const landlordId = decodedToken._id;

        if (!landlordId) {
            return res.status(401).json({ success: false, message: "Invalid token: landlord ID is missing" });
        }

        // Fetch applications linked to this landlord
        const applications = await Application.find({ landlordId });

        console.log("Landlord ID:", landlordId);
        console.log("Fetched Applications:", applications);

        if (applications.length === 0) {
            return res.json({ status: false, success: [] });
        }

        res.json({ status: true, success: applications });
    } catch (error) {
        console.error("Error fetching landlord applications:", error);
        res.status(500).json({ success: false, message: "Internal Server Error", error: error.message });
    }
};



const getApplicationData = async (req, res) => {
    try {
      const authHeader = req.headers.authorization;
      if (!authHeader) {
        return res.status(401).json({ success: false, message: "Authorization header is missing" });
      }
  
      const token = authHeader.split(" ")[1]; // Extract token part after "Bearer"
      if (!token) {
        return res.status(401).json({ success: false, message: "Authorization token is missing" });
      }
  
      const decodedToken = jwt.verify(token, "secretKey");
      const userId = decodedToken._id;
  
      if (!userId) {
        return res.status(401).json({ success: false, message: "Invalid token: user ID is missing" });
      }
  
      const applications = await ApplicationServices.getApplicationData(userId);
  
      console.log("Fetched Applications:", applications);  // Debug log
  
      res.json({ status: true, success: applications });
    } catch (error) {
      console.error("Error during token verification:", error);
      res.status(500).json({ success: false, message: "Internal Server Error", error: error.message });
    }
};

const updateApplicationStatus = async (req, res) => {
    try {
        const { applicationId, status } = req.body;

        if (!['Pending', 'Approved', 'Declined'].includes(status)) {
            return res.status(400).json({ success: false, message: "Invalid status value" });
        }

        const application = await Application.findById(applicationId);
        if (!application) {
            return res.status(404).json({ success: false, message: "Application not found" });
        }

        application.status = status;
        await application.save();

        res.json({ success: true, message: "Application status updated successfully" });
    } catch (error) {
        console.error("Error updating application status:", error);
        res.status(500).json({ success: false, message: "Internal Server Error", error: error.message });
    }
};


module.exports = { submitApplication, getApplicationData, getLandlordApplications, updateApplicationStatus };
