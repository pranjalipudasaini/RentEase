const ApplicationModel = require("../model/application.model");

class ApplicationServices {
static async getApplicationData(userId) {
    const applicationData = await ApplicationModel.find({ userId });
    return applicationData;
}

static async getLandlordApplicationData(landlordId) {
    const landlordApplicationData = await ApplicationModel.find({ landlordId });
    return landlordApplicationData;
}
}

module.exports = ApplicationServices;