exports = async function (arg) {
  const { password, email, user } = arg;
  var crypto = require("crypto");
  const Auth = context.services
    .get("realm-cluster")
    .db("sandbox-db")
    .collection("Auths");

  var salt = crypto.randomBytes(16).toString("hex");
  var hash = crypto
    .pbkdf2Sync(password, salt, 1000, 64, `sha512`)
    .toString(`hex`);
  await Auth.insertOne({
    user,
    email,
    hash,
    salt,
  });
  return { arg: arg };
};
