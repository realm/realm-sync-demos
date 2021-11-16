import {
  Button,
  Col,
  Drawer,
  Form,
  Input,
  Row,
  InputNumber,
} from "antd";
import React from "react";
import { OneItemProps } from "../../common/interfaces/OneItemProps";
import { StoreType } from "../../common/types/Store";
import useUsers from "./context";


interface OneStoreProps extends OneItemProps {
  isOpen: boolean;
  store: StoreType | null;
  onClose: () => void;
}

export const OneStore: React.FC<OneStoreProps> = ({
  isOpen,
  isNew,
  store,
  onClose,
}: OneStoreProps) => {
  const {
    actions: { createOne, updateOne },
  } = useUsers();
  const onSubmit = (values: StoreType) => {
    values = {
      ...values,
      _partition:"master",
    }
    if (isNew) {
      createOne(values, () => {
        onClose();
      });
    } else {
      if (store) {
        updateOne(store._id, values,()=>{
          onClose();
        });
      }
    }
  };

  return (
    <Drawer
      title={isNew ? "Create a new Store" : "Edit the Store"}
      width={"400px"}
      onClose={onClose}
      visible={isOpen}
      bodyStyle={{ paddingBottom: 80 }}
    >
      <Form
        layout="vertical"
        onFinish={onSubmit}
        initialValues={store as any}
      >
        <Row gutter={16}>
          <Col span={24}>
            <Form.Item
              name="name"
              label="Name"
              rules={[
                { required: true, message: "Please enter the product name" },
              ]}
            >
              <Input placeholder="Store Name" />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={24}>
            <Form.Item
              name="address"
              label="Address"
              rules={[
                { required: true, message: "Please enter the address" },
              ]}
            >
              <Input.TextArea placeholder="Address of the store." />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16} style={{ marginTop: 50 }}>
          <Col span={12}>
            <Form.Item>
              <Button htmlType="button" type="text" onClick={onClose}>
                Close
              </Button>
              <Button type="primary" htmlType="submit">
                Submit
              </Button>
            </Form.Item>
          </Col>
        </Row>
      </Form>
    </Drawer>
  );
};
