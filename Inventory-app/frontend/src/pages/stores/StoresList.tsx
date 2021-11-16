import { Button, Table } from "antd";
import React from "react";
import { ListProps } from "../../common/interfaces/ListProps";
import { StoreType } from "../../common/types/Store";
import useStores from "./context";

export interface StoresListProps extends ListProps {
  onEdit: (item: StoreType) => void;
  onInventoriesClicked: (item: StoreType) => void;
}

export const StoresList: React.FC<StoresListProps> = ({
  onEdit,
  onInventoriesClicked,
}: StoresListProps) => {
  const {
    actions: { updateCurrentStore },
    state: { stores },
  } = useStores();
  const columns = [
    {
      title: "Name",
      dataIndex: "name",
      key: "name",
      width: "25%",
    },
    {
      title: "Address",
      key: "address",
      dataIndex: "address",
      width: "25%",
    },
    {
      title: "Products",
      key: "action",
      width: "25%",
      render: (item: StoreType) => (
        <Button
          type="ghost"
          onClick={() => {
            updateCurrentStore(item);
            onInventoriesClicked(item);
          }}
        >
          View Inventory
        </Button>
      ),
    },
    {
      title: "Action",
      key: "action",
      width: "25%",
      render: (item: StoreType) => (
        <Button type="ghost" onClick={() => onEdit(item)}>
          Edit
        </Button>
      ),
    },
  ];

  return (
    <div>
      <Table dataSource={stores} columns={columns} pagination={false} />
    </div>
  );
};
