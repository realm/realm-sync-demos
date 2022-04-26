exports = async function createNewUserDocument({ user }) {
  try{
    const { id, identities = [] } = user;
    const cluster = context.services.get("mongodb-atlas");
    const UsersCollection = cluster.db("sandbox").collection("Users");
    //Filter Identity
    const customFunctionIdentity = identities.find(
      (x) => x.provider_type === "custom-function"
    );
  
    if (id && customFunctionIdentity) {
      return await UsersCollection.updateOne(
        { _id: BSON.ObjectId(customFunctionIdentity.id) },
        { $set: { customDataId: id } }
      );
    }
    return null;
  }catch(e){
    console.log(e)
  }
};
