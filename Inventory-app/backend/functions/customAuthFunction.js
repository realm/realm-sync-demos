
exports = async function (loginPayload) {
  try {
    const charSet = "QWERTYUIOPASDFGHJKLZXCVBNM";
    // Get a handle for the app.users collection
    const users = context.services
      .get("realm-cluster")
      .db("sandbox-db")
      .collection("Users");

    const { email, action, firstName, lastName, userRole, stores, password } =
      loginPayload;
    if (action === "login") {
      const user = await users.findOne({ email });
      if (user) {
        //Check Password match
        const isMatch = await context.functions.execute("checkPassword", {
          email,
          password,
        });
        if (isMatch) {
          return {
            id: user._id.toString(),
            name: `${user.firstName} ${user.lastName}`,
          };
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else if (action === "register") {
      const _id = new BSON.ObjectId();
      let storesId = null;
      if (stores) {
        storesId = new BSON.ObjectId(stores);
      }

      //Generate a random password
      const newPassword = Array(8)
        .fill(null)
        .map(() => charSet.charAt(Math.floor(Math.random() * charSet.length)))
        .join("");

      // If the user document does not exist, create it and then return its unique ID
      const result = await users.insertOne({
        _id,
        email,
        firstName,
        lastName,
        userRole,
        stores: storesId,
        _partition: "master",
      });
      context.functions.execute("hashPassword", {
        user: _id,
        email,
        password: newPassword,
      });

      const emailStatus = await context.functions.execute("sendEmailToUser", {
        email,
        password: newPassword,
        firstName,
        lastName,
      });
      console.log(emailStatus);
      return {
        id: result.insertedId.toString(),
        name: `${firstName} ${lastName}`,
      };
    }
  } catch (e) {
    console.log(e);
    return null;
  }
};
