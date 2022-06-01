exports = async ({userType, userData, uuid}) => {
    return new Promise(async (resolve, reject) => {
        try {
            var patient = context.services.get("mongodb-atlas").db("refactor").collection("Patient");
            var practitioner = context.services.get("mongodb-atlas").db("refactor").collection("Practitioner");
            referenceId = new BSON.ObjectId();
            var users = context.services.get("mongodb-atlas").db("refactor").collection("AuthUsers");
            const userObject = {
                _id: referenceId,
                identifier:uuid,
                active:true,
                birthDate:new Date(userData.birthDate),
                gender:userData.gender||"male",
                name:{
                    text:`${userData.firstName} ${userData.lastName}`,
                    prefix:[userData.gender==="male"?"Mr":"Mrs"],
                    suffix:["."],
                    given:userData.firstName
                }
            }
            await users.insertOne({
                userType,
                ...userData,
                uuid,
                createdAt: new Date(),
                referenceId
            });
            if(userType==="patient"){
                patient.insertOne(userObject)
            }else{
                practitioner.insertOne({...userObject,about:""})
            }
            return resolve(true);
        } catch (e) {
            return reject(e);
        }
    })
};