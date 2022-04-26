exports = function (arg) {
  const { password, email } = arg;
  var crypto = require("crypto");
  const Auth = context.services
    .get("mongodb-atlas")
    .db("sandbox")
    .collection("Auths");

  return new Promise(async (resolve, reject) => {
    try {
      const user = await Auth.findOne({ email });
      if (user) {
        const { salt, hash } = user;
        var calculatedHash = crypto
          .pbkdf2Sync(password, salt, 1000, 64, `sha512`)
          .toString(`hex`);
        resolve(calculatedHash === hash);
      } else {
        reject(null);
      }
    } catch (e) {
      reject(e);
    }
  });
};
