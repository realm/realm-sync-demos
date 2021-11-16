//Realm Provider from https://github.com/mongodb-university/realm-tutorial-web.git

import React from "react";
import * as Realm from "realm-web";

const RealmAppContext = React.createContext();

export const useRealmApp = () => {
  const app = React.useContext(RealmAppContext);
  if (!app) {
    throw new Error(
      `You must call useRealmApp() inside of a <RealmAppProvider />`
    );
  }
  return app;
};

export const RealmAppProvider = ({ appId, children }) => {
  const [app, setApp] = React.useState(new Realm.App(appId));
  React.useEffect(() => {
    setApp(new Realm.App(appId));
  }, [appId]);

  // Wrap the Realm.App object's user state with React state
  const [currentUser, setCurrentUser] = React.useState(app.currentUser);
  const [profile, setProfileInfo] = React.useState(
    app.currentUser ? app.currentUser.customData : null
  );
  async function logIn(credentials) {
    // const credentials1 = Realm.Credentials.function({email:"c1@mailinator.com", action:"login"});
    // await app.logIn(credentials1);
    await app.logIn(credentials);
    console.log(app.currentUser);
    // If successful, app.currentUser is the user that just logged in
    setCurrentUser(app.currentUser);
    setProfileInfo(app.currentUser ? app.currentUser.customData : null);
  }

  async function register(credentials) {
    return new Promise(async (resolve, reject) => {
      try {
        const registeredUser = await app.logIn(credentials);
        console.log(registeredUser);
        //A work around because, registered user will be automatically logged in on the custom-function provider.
        registeredUser.logOut();
        resolve(true);
      } catch (e) {
        reject(e);
      }
    });
  }
  async function logOut() {
    // Log out the currently active user
    await app.currentUser?.logOut();
    localStorage.clear(); 
    // If another user was logged in too, they're now the current user.
    // Otherwise, app.currentUser is null.
    setCurrentUser(app.currentUser);
    setProfileInfo(app.currentUser ? app.currentUser.customData : null);
  }

  const wrapped = { ...app, currentUser, logIn, logOut, profile, register };

  return (
    <RealmAppContext.Provider value={wrapped}>
      {children}
    </RealmAppContext.Provider>
  );
};
