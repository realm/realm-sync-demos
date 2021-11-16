import React from "react";
import { PageProps } from "../../common/interfaces/PageProps";
import { StoresList } from "./StoresList";
import useStores, { StoreProvider } from "./context";
import { Button, PageHeader } from "antd";
import { PlusOutlined } from "@ant-design/icons";
import { StoreType } from "../../common/types/Store";
import { OneStore } from "./OneStore";
import { ProductProvider } from "../products/context";
import { Inventories } from "./Inventories";
export interface StoresPageProps extends PageProps {}

export const Stores: React.FC<StoresPageProps> = (_props: StoresPageProps) => {
  const [openNew, setOpen] = React.useState(false);
  const [openInventories, setInventories] = React.useState(false);
  const [currentStore, setCurrentStore] = React.useState<StoreType | null>(
    null
  );
  return (
    <div>
      <ProductProvider>
        <StoreProvider>
          <PageHeader
            title="Stores"
            subTitle="A master collection of all the stores."
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
            style={{
              padding: "20px",
              minHeight: "100%",
              height: "max-content",
            }}
          >
            <StoresList
              onEdit={(item) => {
                setCurrentStore(item);
                setOpen(true);
              }}
              onInventoriesClicked={(item) => {
                setCurrentStore(item);
                setInventories(true);
              }}
            />
          </div>
          {openNew && (
            <OneStore
              store={currentStore}
              isNew={currentStore === null}
              onClose={() => {
                setOpen(false);
                setCurrentStore(null);
              }}
              isOpen
            />
          )}
          {openInventories && (
            <Inventories
              store={currentStore}
              onClose={() => {
                setInventories(false);
                setCurrentStore(null);
              }}
              isOpen
            />
          )}
        </StoreProvider>
      </ProductProvider>
    </div>
  );
};
