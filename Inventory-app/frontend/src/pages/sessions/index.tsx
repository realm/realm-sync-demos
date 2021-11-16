import React from "react";
import { PageProps } from "../../common/interfaces/PageProps";
import { Switch, Route, Redirect } from "react-router-dom";
import { Login } from "./Login";
export interface SessionPageProps extends PageProps {}

export const Sessions: React.FC<SessionPageProps> = (
  _props: SessionPageProps
) => {
  return (
    <Switch>
      <Route path="/sessions/login" exact component={Login} />
      <Redirect from="/" to="/sessions/login" />
    </Switch>
  );
};
