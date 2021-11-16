import { LayoutContainer } from "./common/Layout";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  Redirect,
} from "react-router-dom";
import { Products, Sessions, Stores, Users } from "./pages";
import { useRealmApp, RealmAppProvider } from "./RealmApp.js";
import { MenuBar } from "./common/MenuBar";
import {
  AuthenticatedRoutes,
  UnAuthenticatedRoutes,
} from "./routes/AuthenticatedRoute";
import RealmApolloProvider from "./RealmApolloProvider";
import { Jobs } from "./pages/jobs";

function App() {
  return (
    <RealmAppProvider appId={process.env.REACT_APP_REALM_APP_ID}>
      <RealmApolloProvider>
        <Router>
          <LayoutContainer>
            <MenuBar />
            <div
              style={{
                padding: "10px",
                margin: "10px",
                backgroundColor: "white",
                minHeight: "100%",
              }}
            >
              <Switch>
                <AuthenticatedRoutes path="/products">
                  <Products />
                </AuthenticatedRoutes>
                <AuthenticatedRoutes path="/users">
                  <Users />
                </AuthenticatedRoutes>
                <AuthenticatedRoutes path="/stores">
                  <Stores />
                </AuthenticatedRoutes>
                <AuthenticatedRoutes path="/jobs">
                  <Jobs />
                </AuthenticatedRoutes>
                <UnAuthenticatedRoutes path="/sessions">
                  <Sessions />
                </UnAuthenticatedRoutes>
                <Redirect from="/" exact to="/jobs" />
              </Switch>
            </div>
          </LayoutContainer>
        </Router>
      </RealmApolloProvider>
    </RealmAppProvider>
  );
}

export default App;
