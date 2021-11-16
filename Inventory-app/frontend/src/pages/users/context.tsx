import React from "react";
import { generateContext } from "../../ContextGenerator";
import { useQuery } from "@apollo/client";
import { useRealmApp } from "../../RealmApp";
import gql from "graphql-tag";
import { UserType } from "../../common/types/User";
import * as Realm from "realm-web";
import { message } from 'antd';
type State = {
  users: UserType[];
};

const initialState: State = {
  users: [],
};

const reducer = (
  state: State,
  {
    type,
    payload,
  }: {
    type: "FETCH_ALL" | "UPDATE_ONE";
    payload: any;
  }
): State => {
  switch (type) {
    case "FETCH_ALL":
      return { ...state, users: payload };
    default:
      return state;
  }
};
export const {
  useContext: useUsers,
  Context: UserContext,
  Provider: UserProvider,
} = generateContext(() => {
  const [state, dispatch] = React.useReducer(reducer, initialState);
  const app = useRealmApp();
  const {
    data,
    loading,
    refetch,
  } = useQuery(
    gql`
      {
        users(sortBy:_ID_DESC) {
          firstName
          lastName
          userRole
          _id
          email
          stores {
            _id
            name
            address
          }
        }
      }
    `,
    { variables: {}, notifyOnNetworkStatusChange:true }
  );

  React.useEffect(()=>{
    if(loading){
      message.loading({content:"Loading...", key:"loading"})
    }else{
      message.destroy("loading")
    }
  }, [loading])

  React.useEffect(() => {
    if (data) {
      dispatch({ type: "FETCH_ALL", payload: data.users || [] });
    }
  }, [data]);

  const createOneUser = async (
    user: UserType,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Creating...", key: "create" });
      const credentials = Realm.Credentials.function({
        ...user,
        action: "register",
      });
      await app.register(credentials);
      message.destroy("create")
      refetch();
      if (callback) {
        callback();
      }
    } catch (e) {
      console.log(e);
    }
  };

  return {
    state,
    actions: { createOneUser },
  };
});

export default useUsers;
