export type StoreType = {
  name: string;
  address: string;
  _partition: string;
  _id?: any;
};

export type StoreInventoryTypes = {
  _id?: any;
  sku:string;
  productName:string;
  productId:any;
  quantity:string|number;
  storeId:any;
  _partition:string;
  image:string;
}