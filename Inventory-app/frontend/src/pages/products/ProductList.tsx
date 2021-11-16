import { Button, Table, Typography, Image } from "antd";
import React from "react";
import { ListProps } from "../../common/interfaces/ListProps";
import { ProductType } from "../../common/types/Product";
import useProducts from "./context";

const { Paragraph, Title } = Typography;

export interface ProductListProps extends ListProps {
  onEdit: (item: ProductType) => void;
}

export const ProductList: React.FC<ProductListProps> = ({
  onEdit,
}: ProductListProps) => {
  const {
    actions: {},
    state: { products },
  } = useProducts();

  const columns = [
    {
      title: "SKU",
      dataIndex: "sku",
      key: "sku",
      width: "16%",
    },
    {
      title: "Product Image",
      key: "image",
      width: "16%",
      render: (item: ProductType) => (
        <Image width={70} height={70} src={item.image} />
      ),
    },
    {
      title: "Name",
      key: "name",
      width: "20%",
      render: (item: ProductType) => (
        <div style={{ display: "block" }}>
          <Title level={5}>{item.name}</Title>
          <Paragraph>{item.detail}</Paragraph>
        </div>
      ),
    },
    {
      title: "Price",
      key: "price",
      width: "16%",
      render: (item: ProductType) => (
        <Title level={5} style={{paddingLeft:30}}>{`$ ${item.price}`}</Title>
      ),
    },
    {
      title: "Available Quantity",
      key: "totalQuantity",
      width: "16%",
      render: (item: ProductType) => (
        <Title level={5} style={{paddingLeft:30}}>{`${item.totalQuantity}`}</Title>
      ),
    },
    {
      title: "Action",
      key: "action",
      width: "16%",
      render: (item: ProductType) => (
        <Button type="ghost" onClick={() => onEdit(item)}>
          Edit
        </Button>
      ),
    },
  ];
  return (
    <div>
      <Table dataSource={products} columns={columns} pagination={false} />
    </div>
  );
};
