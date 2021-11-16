import React from "react";
import { generateContext } from "../../ContextGenerator";
import { useMutation, useQuery, useLazyQuery } from "@apollo/client";
import gql from "graphql-tag";
import { StoreType, StoreInventoryTypes } from "../../common/types/Store";
import { message } from "antd";
import { ObjectId } from "bson";
import useProducts from "../products/context";
import { ProductType } from "../../common/types/Product";
type State = {
  stores: StoreType[];
  currentStore: StoreType | null;
  storeInventories: StoreInventoryTypes[];
};

const initialState: State = {
  stores: [],
  currentStore: null,
  storeInventories: [],
};

const reducer = (
  state: State,
  {
    type,
    payload,
  }: {
    type:
      | "FETCH_ALL"
      | "UPDATE_CURRENT_STORE"
      | "FETCH_INVENTORIES"
      | "CLEAR_STORE_AND_INVENTORY";
    payload: any;
  }
): State => {
  switch (type) {
    case "CLEAR_STORE_AND_INVENTORY":
      return { ...state, currentStore: null, storeInventories: [] };
    case "UPDATE_CURRENT_STORE":
      return { ...state, currentStore: payload };
    case "FETCH_INVENTORIES":
      return { ...state, storeInventories: payload };
    case "FETCH_ALL":
      return { ...state, stores: payload };
    default:
      return state;
  }
};
export const {
  useContext: useStores,
  Context: StoreContext,
  Provider: StoreProvider,
} = generateContext(() => {
  const {actions:{updateProductQuantity} } = useProducts();
  const [state, dispatch] = React.useReducer(reducer, initialState);
  const [addStore] = useMutation(gql`
    mutation InsertAStore($store: StoreInsertInput!) {
      addStore: insertOneStore(data: $store) {
        _id
      }
    }
  `);
  const [updateStore] = useMutation(gql`
    mutation UpdateAStore($_id: ObjectId!, $updates: StoreUpdateInput!) {
      updateStore: updateOneStore(query: { _id: $_id }, set: $updates) {
        _id
      }
    }
  `);

  const [addStoreInventory] = useMutation(gql`
    mutation InsertOneStoreInventory(
      $storeInventory: StoreInventoryInsertInput!
    ) {
      addStoreInventory: insertOneStoreInventory(data: $storeInventory) {
        _id
      }
    }
  `);


  const [
    loadInventories,
    {
      data: storeInventories,
      loading: inventoryLoading,
      refetch: refetchStoreInventory,
    },
  ] = useLazyQuery(
    gql`
      query fetchStroreInventories($forStore: ObjectId!) {
        storeInventories(query: { storeId: $forStore }) {
          image
          productName
          productId
          quantity
        }
      }
    `,
    {
      fetchPolicy: "no-cache",
      nextFetchPolicy: "no-cache",

    }
  );

  const {
    data: allStores,
    loading,
    refetch,
  } = useQuery(
    gql`
      {
        stores(sortBy:_ID_DESC) {
          _id
          _partition
          name
          address
        }
      }
    `,
    { variables: {}, notifyOnNetworkStatusChange: true }
  );

  React.useEffect(() => {
    if (loading || inventoryLoading) {
      message.loading({ content: "Loading...", key: "loading" });
    } else {
      message.destroy("loading");
    }
  }, [loading, inventoryLoading]);

  React.useEffect(() => {
    if (storeInventories) {
      dispatch({
        type: "FETCH_INVENTORIES",
        payload: storeInventories.storeInventories || [],
      });
    }
  }, [storeInventories]);

  React.useEffect(() => {
    if (allStores) {
      dispatch({ type: "FETCH_ALL", payload: allStores.stores || [] });
    }
  }, [allStores]);

  const fetchAllStoreInventories = () => {
    loadInventories({
      variables: { forStore: state.currentStore ? state.currentStore._id : "" },
    });
  };

  const fetchAllStoreInventoriesWith = (storeId:string) => {
    loadInventories({
      variables: { forStore: storeId },
    });
  };

  const createOne = async (
    store: StoreType,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Creating...", key: "create" });
      await addStore({ variables: { store } });
      if (callback) {
        callback();
      }
      message.destroy("create");
      refetch();
    } catch (e) {
      console.log(e);
    }
  };

  const updateOne = async (
    id: string,
    store: StoreType,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Updating...", key: "update" });
      await updateStore({
        variables: { _id: new ObjectId(id), updates: store },
      });
      if (callback) {
        callback();
      }
      message.destroy("update");
      refetch();
    } catch (e) {
      console.log(e);
    }
  };

  const createOneStoreInventory = async (
    storeInventory: Partial<StoreInventoryTypes>,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Creating...", key: "create" });
      await addStoreInventory({ variables: { storeInventory } });
      await updateProductQuantity(storeInventory.productId, storeInventory.quantity)
      if (callback) {
        callback();
      }
      message.destroy("create");
      refetchStoreInventory &&
        refetchStoreInventory({
          forStore: state.currentStore ? state.currentStore._id : "",
        });
    } catch (e) {
      console.log(e);
    }
  };

  
  return {
    state,
    actions: {
      createOne,
      updateOne,
      fetchAllStoreInventories,
      createOneStoreInventory,
      fetchAllStoreInventoriesWith,
      clearStoreAndInventory: () =>
        dispatch({ type: "CLEAR_STORE_AND_INVENTORY", payload: {} }),
      updateCurrentStore: (store: StoreType | null) =>
        dispatch({ type: "UPDATE_CURRENT_STORE", payload: store }),
    },
  };
});

export default useStores;
