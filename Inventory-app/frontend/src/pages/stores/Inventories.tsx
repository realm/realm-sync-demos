import { PlusOutlined } from "@ant-design/icons";
import {
  Button,
  Drawer,
  Form,
  Table,
  Typography,
  Select,
  InputNumber,
  Image,
  message,
} from "antd";
import React from "react";
import { ProductType } from "../../common/types/Product";
import { StoreInventoryTypes, StoreType } from "../../common/types/Store";
import useProducts from "../products/context";
import useStores from "./context";
const { Option } = Select;
const { Title } = Typography;

interface InventoryProps {
  isOpen: boolean;
  store: StoreType | null;
  onClose: () => void;
}

export const Inventories: React.FC<InventoryProps> = ({
  isOpen,
  store,
  onClose,
}: InventoryProps) => {
  const [addNew, setAddNew] = React.useState(false);
  const [productList, setProductList] = React.useState<ProductType[]>([]);
  const {
    state: { storeInventories },
    actions: {
      fetchAllStoreInventories,
      clearStoreAndInventory,
      createOneStoreInventory,
    },
  } = useStores();
  const {
    state: { products },
  } = useProducts();
  React.useEffect(() => {
    fetchAllStoreInventories();
  }, []);

  React.useEffect(() => {
    setProductList(
      products.filter(function (p) {
        return !storeInventories.some(function (i) {
          return p._id == i.productId;
        });
      })
    );
  }, [products, storeInventories]);

  const onSubmit = (values: StoreInventoryTypes) => {
    const product = productList.find((x) => x._id === values.productId);

    if (store && product) {
      if (values.quantity > product?.totalQuantity) {
        return message.error({
          content: "Allocation should be lesser than the available quantity.",
        });
      } else {
        values = {
          ...values,
          quantity: values.quantity.toString(),
          _partition: `store=${store._id}`,
          productName: product.name,
          storeId: store._id,
          image: product.image,
        };
      }
      createOneStoreInventory(values, () => {
        setAddNew(false);
      });
    }
  };

  return (
    <Drawer
      title={"Store Inventories"}
      width={"500px"}
      onClose={() => {
        clearStoreAndInventory();
        onClose();
      }}
      visible={isOpen}
      bodyStyle={{
        paddingBottom: 80,
        padding: 0,
        overflow: "scroll",
        height: "100vh",
      }}
    >
      <>
        <Title level={5} style={{ padding: 20 }}>
          List of products in the store inventory{" "}
        </Title>
        <div>
          {!addNew ? (
            <Button
              type="link"
              style={{ fontWeight: 900, float: "right" }}
              onClick={() => setAddNew(true)}
            >
              <PlusOutlined />
              Add New
            </Button>
          ) : (
            <div id="add-new-form" style={{ padding: 20, width: "100%" }}>
              <Form layout="vertical" onFinish={onSubmit}>
                <Form.Item
                  label="Product"
                  name="productId"
                  style={{ width: "100%" }}
                  rules={[
                    {
                      required: true,
                      message: "Please enter the product name",
                    },
                  ]}
                >
                  <Select
                    showSearch
                    placeholder="Select a product to be added to the inventory"
                    optionFilterProp="children"
                    allowClear
                  >
                    {productList.map((item: ProductType) => (
                      <Option value={item._id}>
                        <div
                          style={{
                            display: "flex",
                            justifyContent: "space-between",
                            alignItems: "center",
                          }}
                        >
                          {item.name}{" "}
                          <span style={{ fontSize: "12px", opacity: 0.6 }}>
                            Available Quantity:{item.totalQuantity}
                          </span>
                        </div>
                      </Option>
                    ))}
                  </Select>
                </Form.Item>
                <Form.Item
                  label="Quantity to allocate"
                  name="quantity"
                  style={{ width: "100%" }}
                  rules={[
                    {
                      required: true,
                      message: "Please enter the product name",
                    },
                  ]}
                >
                  <InputNumber style={{ width: "100%" }} />
                </Form.Item>
                <Form.Item>
                  <Button type="text" onClick={() => setAddNew(false)}>
                    Close
                  </Button>
                  <Button type="primary" htmlType="submit">
                    Submit
                  </Button>
                </Form.Item>
              </Form>
            </div>
          )}
          <Table
            style={{ padding: 20 }}
            dataSource={storeInventories}
            columns={[
              {
                title: "Product Image",
                key: "image",
                width: "33%",
                render: (item) => (
                  <Image width={70} height={70} src={item.image} />
                ),
              },
              {
                title: "Product Name",
                key: "productId",
                width: "33%",
                dataIndex: "productName",
              },
              {
                title: "Available Quantity",
                key: "productId",
                width: "33%",
                dataIndex: "quantity",
              },
            ]}
            pagination={false}
          ></Table>
        </div>
      </>
    </Drawer>
  );
};
