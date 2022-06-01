
/*

  This function will be run when a user logs in with this provider.

  The return object must contain a string id, this string id will be used to login with an existing
  or create a new user. This is NOT the Realm user id, but it is the id used to identify which user has
  been created or logged in with.

  If an error is thrown within the function the login will fail.

  The default function provided below will always result in failure.
*/


exports = async ({ email, password, userType, userData }) => {
    var crypto = require("crypto");
    const returnRandomString = () => {
        var id = crypto.randomBytes(20).toString('hex');
        return id;
    }


    // userData: {"firstName":"Ramachandran", "lastName":"Gunasekeran", "gender":"male", "birthDate":"29-09-1992"}
    // userType: doctor/nurse & patient
    const mdb = context.services.get("mongodb-atlas");
    const Auths = mdb.db("refactor").collection("Auths");
    // Check if the user already exist.
    const existingUser = await Auths.findOne({ email });
    if (existingUser) {
        const { firstName, lastName, uuid, salt, hash } = existingUser;
        var newHash = crypto.pbkdf2Sync(password, salt, 1000, 64, `sha512`).toString(`hex`);
        if (newHash === hash) {
            return { id: uuid, name: `${firstName} ${lastName}` }
        } else {
            throw new Error(`Authentication failed with reason: Password not matching`);
        }
    } else {
        const uuid = returnRandomString();
        if (!userData) {
            throw new Error(`Cannot register a new user, Basic Informations not found.`);
        }
        const { firstName, lastName } = userData;
        if (!firstName || !lastName) {
            throw new Error(`Cannot register a new user, Basic Informations not found.`);
        }
        const salt = crypto.randomBytes(16).toString('hex');
        hash = crypto.pbkdf2Sync(password, salt,
            1000, 64, `sha512`).toString(`hex`);
        await Auths.insertOne({ email, hash, userType, uuid, lastName, firstName, salt });
        await context.functions.execute("createProspect", { userType, userData, uuid });
        return { id: uuid, name: `${firstName} ${lastName}` }
    }
};
