import { Button, Form, InputNumber, Modal, Select } from "antd";
import React from "react";
import { StoreInventoryTypes } from "../../common/types/Store";
const { Option } = Select;
interface ProductInterface {
  onClose: () => void;
  onSelected: (inventory: any) => void;
  inventories: StoreInventoryTypes[];
}

export const AddProduct: React.FC<ProductInterface> = ({
  onClose,
  onSelected,
  inventories,
}: ProductInterface) => {
  const [selectedProduct, setSelectedProduct] =
    React.useState<StoreInventoryTypes | null>(null);
  return (
    <Modal
      title="Add New Product"
      visible={true}
      footer={null}
    >
      <Form layout="vertical" onFinish={(values:any )=>onSelected({...values, ...selectedProduct})}>
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
            onChange={(productId: string) => {
              const product = inventories.find((x) => x.productId == productId);
              if (product) {
                setSelectedProduct(product);
              } else {
                setSelectedProduct(null);
              }
            }}
          >
            {inventories.map((item: StoreInventoryTypes) => (
              <Option value={item.productId}>
                <div
                  style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                  }}
                >
                  {item.productName}
                  <span style={{ fontSize: "12px", opacity: 0.6 }}>
                    Available Quantity:{item.quantity}
                  </span>
                </div>
              </Option>
            ))}
          </Select>
        </Form.Item>
        {selectedProduct && <Form.Item
          label="Quantity to Transfer"
          name="transferQuantity"
          style={{ width: "100%" }}
          rules={[
            {
              required: true,
              message: "Please enter the product name",
            },
          ]}
        >
          <InputNumber
            placeholder="input placeholder"
            style={{ width: "100%" }}
            max={selectedProduct.quantity}
          />
        </Form.Item>}
        
        <Form.Item>
          <Button type="text" onClick={() => onClose()}>
            Close
          </Button>
          <Button type="primary" htmlType="submit">
            Submit
          </Button>
        </Form.Item>
      </Form>
    </Modal>
  );
};
