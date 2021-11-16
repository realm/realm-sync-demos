import React from "react";
import { PageProps } from "../../common/interfaces/PageProps";
import { ProductList } from "./ProductList";
import { PageHeader, Button } from "antd";
import { PlusOutlined } from "@ant-design/icons";
import { ProductProvider } from "./context";
import { OneProduct } from "./OneProduct";
import { ProductType } from "../../common/types/Product";
export interface ProductPageProps extends PageProps {}

export const Products: React.FC<ProductPageProps> = (
  _props: ProductPageProps
) => {
  const [openNew, setOpen] = React.useState(false);
  const [currentProduct, setCurrentProduct] =
    React.useState<ProductType | null>(null);
  return (
    <div>
      <ProductProvider>
        <PageHeader
          title="Products"
          subTitle="A master collection of all the products in the inventory."
          extra={[
            <Button
              type="primary"
              onClick={() => {
                setOpen(true);
              }}
            >
              <PlusOutlined /> Add New
            </Button>,
          ]}
        />
        <div
          style={{ padding: "20px", minHeight: "100%", height: "max-content" }}
        >
          <ProductList
            onEdit={(item) => {
              setCurrentProduct(item);
              setOpen(true);
            }}
          />
        </div>
        {openNew && (
          <OneProduct
            product={currentProduct}
            isNew={currentProduct === null}
            onClose={() => {
              setOpen(false);
              setCurrentProduct(null);
            }}
            isOpen
          />
        )}
      </ProductProvider>
    </div>
  );
};
