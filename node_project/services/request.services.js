const RequestModel = require('../model/request.model');

exports.createRequest = async (data) => {
    try {
      console.log('Attempting to save:', data);
      const request = new RequestModel(data);
      const savedRequest = await request.save();
      console.log('Successfully saved:', savedRequest);
      return savedRequest;
    } catch (error) {
      console.error('Save error:', error);
      throw error;
    }
  };

exports.getAllRequests = async () => {
  return await RequestModel.find().sort({ createdAt: -1 });
};
