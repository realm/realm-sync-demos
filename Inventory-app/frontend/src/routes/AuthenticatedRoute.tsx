import { Redirect, Route, RouteProps } from "react-router-dom";
import { useRealmApp } from "../RealmApp";

interface AuthRoutesProps extends RouteProps {}

export const AuthenticatedRoutes: React.FC<AuthRoutesProps> = ({
  children,
  ...rest
}) => {
  let { currentUser } = useRealmApp();
  return (
    <Route
      {...rest}
      render={({ location }) =>
        currentUser ? (
          children
        ) : (
          <Redirect
            to={{
              pathname: "/sessions",
              state: { from: location },
            }}
          />
        )
      }
    />
  );
};

export const UnAuthenticatedRoutes: React.FC<AuthRoutesProps> = ({
  children,
  ...rest
}) => {
  let user = useRealmApp();
  return (
    <Route
      {...rest}
      render={({ location }) =>
        !user.currentUser ? (
          children
        ) : (
          <Redirect
            to={{
              pathname: "/",
            }}
          />
        )
      }
    />
  );
};
