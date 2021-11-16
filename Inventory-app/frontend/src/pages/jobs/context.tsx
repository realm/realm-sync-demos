import React from "react";
import { generateContext } from "../../ContextGenerator";
import { useMutation, useQuery } from "@apollo/client";
import gql from "graphql-tag";
import { JobType } from "../../common/types/Jobs";
import { message } from "antd";
import { ObjectId } from "bson";
type State = {
  jobs: JobType[];
};

const initialState: State = {
  jobs: [],
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
      return { ...state, jobs: payload };
    default:
      return state;
  }
};
export const {
  useContext: useJobs,
  Context: JobContext,
  Provider: JobProvider,
} = generateContext(() => {
  
  const [state, dispatch] = React.useReducer(reducer, initialState);
  const [addJob] = useMutation(gql`
    mutation InsertAJob($product: JobInsertInput!) {
      addJob: insertOneJob(data: $product) {
        _id
      }
    }
  `);
  const [updateJob] = useMutation(gql`
    mutation UpdateAJob($_id: ObjectId!, $updates: JobUpdateInput!) {
      updateJob: updateOneJob(query: { _id: $_id }, set: $updates) {
        _id
      }
    }
  `);
  const { data, loading, refetch } = useQuery(
    gql`
      {
        jobs(sortBy:PICKUPDATETIME_ASC) {
          _id
          status
          assignedTo {
            _id
            firstName
            lastName
          }
          sourceStore {
            _id
            name
          }
          destinationStore {
            _id
            name
          }
          _partition
          pickupDatetime
          createdBy {
            _id
            firstName
            lastName
          }
          products {
            product {
              _id
              name
            }
            quantity
          }
        }
      }
    `,
    { variables: {}, notifyOnNetworkStatusChange: true }
  );

  React.useEffect(() => {
    if (loading) {
      message.loading({ content: "Loading...", key: "loading" });
    } else {
      message.destroy("loading");
    }
  }, [loading]);

  React.useEffect(() => {
    if (data) {
      const doneJobs = data.jobs.filter((x:any)=> x.status==="done");
      const nonDoneJobs = data.jobs.filter((x:any)=> x.status!=="done");
      dispatch({ type: "FETCH_ALL", payload:[...nonDoneJobs,...doneJobs] });
    }
  }, [data]);

  const createOne = async (
    product: JobType,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Creating...", key: "create" });
      await addJob({ variables: { product } });
      if (callback) {
        callback();
      }
      message.destroy('create')
      refetch();
    } catch (e) {
      console.log(e);
    }
  };

  const updateOne = async (
    id: string,
    job: Partial<JobType>,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Updating...", key: "update" });
      await updateJob({
        variables: { _id: new ObjectId(id), updates: job },
      });
      if (callback) {
        callback();
      }
      message.destroy('update')
      refetch();
    } catch (e) {
      console.log(e);
    }
  };

  return {
    state,
    actions: { createOne, updateOne },
  };
});

export default useJobs;
