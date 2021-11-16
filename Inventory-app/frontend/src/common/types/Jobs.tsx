import { StoreType } from "./Store";

type Product = {
    product: any
    quantity: string
}

export type JobType = {
  status: string;
  assignedTo: any;
  destinationStore: Partial<StoreType>;
  sourceStore:Partial<StoreType>;
  pickupDatetime: any;
  createdBy: any;
  price: number;
  products: Product[];
  _partition: string;
  _id?: any;
};
