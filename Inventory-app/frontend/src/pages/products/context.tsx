import React from "react";
import { generateContext } from "../../ContextGenerator";
import { useMutation, useQuery } from "@apollo/client";
import gql from "graphql-tag";
import { ProductType } from "../../common/types/Product";
import { message } from "antd";
import { ObjectId } from "bson";




type State = {
  products: ProductType[];
};

const initialState: State = {
  products: [],
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
      return { ...state, products: payload };
    default:
      return state;
  }
};
export const {
  useContext: useProducts,
  Context: ProductContext,
  Provider: ProductProvider,
} = generateContext(() => {
  const [state, dispatch] = React.useReducer(reducer, initialState);
  const [addProduct] = useMutation(gql`
    mutation InsertAProduct($product: ProductInsertInput!) {
      addProduct: insertOneProduct(data: $product) {
        _id
      }
    }
  `);
  const [updateProduct] = useMutation(gql`
    mutation UpdateAProduct($_id: ObjectId!, $updates: ProductUpdateInput!) {
      updateProduct: updateOneProduct(query: { _id: $_id }, set: $updates) {
        _id
        name
      }
    }
  `);
  const { data, loading, refetch } = useQuery(
    gql`
      {
        products(sortBy:_ID_DESC) {
          _id
          _partition
          detail
          image
          name
          price
          sku
          totalQuantity
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
      dispatch({ type: "FETCH_ALL", payload: data.products || [] });
    }
  }, [data]);

  const createOne = async (
    product: ProductType,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Creating...", key: "create" });
      await addProduct({ variables: { product } });
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
    product: ProductType,
    callback?: (data?: any) => void
  ) => {
    try {
      message.loading({ content: "Updating...", key: "update" });
      await updateProduct({
        variables: { _id: new ObjectId(id), updates: product },
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

  const updateProductQuantity = async (
    id: string,
    quantity: any,
    callback?: (data?: any) => void
  ) => {
    try {
      const existingProduct = state.products.find(
        (x: ProductType) => x._id == id
      );
      if (existingProduct) {
        let { totalQuantity }: any = existingProduct;
        totalQuantity = parseInt(totalQuantity) - parseInt(quantity);
        await updateProduct({
          variables: {
            _id: new ObjectId(id),
            updates: { totalQuantity: totalQuantity.toString() },
          },
        });
        if (callback) {
          callback();
        }
        refetch();
      }
    } catch (e) {
      console.log(e);
    }
  };

  return {
    state,
    actions: { createOne, updateOne, updateProductQuantity },
  };
});

export default useProducts;
