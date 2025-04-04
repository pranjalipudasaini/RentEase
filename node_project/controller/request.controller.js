const RequestModel = require('../model/request.model');  
const requestService = require('../services/request.services');

exports.createRequest = async (req, res) => {
    try {
      console.log('Raw body:', req.body);
      console.log('File:', req.file);  // This helps to check if the image is being uploaded correctly
      
      const { title, description, priority } = req.body;
      const imageUrl = req.file ? req.file.filename : null;

      console.log('Processed data:', { title, description, priority, imageUrl });
      
      const request = await requestService.createRequest({
        title,
        description,
        priority,
        imageUrl,
      });

      console.log('Saved request ID:', request._id);
      res.status(201).json({ success: true, data: request });
    } catch (error) {
      console.error('Full error:', error); // Make sure you log the full error
      res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
};

