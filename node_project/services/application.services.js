const ApplicationModel = require("../model/application.model");

class ApplicationServices {
static async getApplicationData(userId) {
    const applicationData = await ApplicationModel.find({ userId });
    return applicationData;
}
}

module.exports = ApplicationServices;