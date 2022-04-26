exports = async function checkEmailExist({email}) {
  try{
    const cluster = context.services.get("mongodb-atlas");
    const AuthCollection = cluster.db("sandbox").collection("Auths")
    return AuthCollection.findOne(
        { email}
      );
  }catch(e){
    console.log(e)
  }
};


