const ApplicationModel = require("../model/application.model");

class ApplicationServices {
    static async getApplicationData(userId) {
        console.log("Fetching applications for userId:", userId);
        const applicationData = await ApplicationModel.find({ userId });
        console.log("Fetched Applications:", applicationData);
        return applicationData;
    }
    

static async getLandlordApplicationData(landlordId) {
    const landlordApplicationData = await ApplicationModel.find({ landlordId });
    return landlordApplicationData;
}
}

module.exports = ApplicationServices;