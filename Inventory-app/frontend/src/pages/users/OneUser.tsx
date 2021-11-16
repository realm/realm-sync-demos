import { Button, Col, Drawer, Form, Input, Row, Select } from "antd";
import React from "react";
import { OneItemProps } from "../../common/interfaces/OneItemProps";
import { StoreType } from "../../common/types/Store";
import { UserType } from "../../common/types/User";
import useStores from "../stores/context";
import useUsers from "./context";

const { Option } = Select;

interface OneUserProps extends OneItemProps {
  isOpen: boolean;
  user: UserType | null;
  onClose: () => void;
}

export const OneUser: React.FC<OneUserProps> = ({
  isOpen,
  onClose,
}: OneUserProps) => {
  const {
    actions: { createOneUser },
  } = useUsers();
  const {
    state: { stores },
  } = useStores();
  const [canShowStore, setShowStore] = React.useState(false);
  const onSubmit = (values: UserType) => {
    createOneUser(values, () => {
      onClose();
    });
  };

  return (
    <Drawer
      title="Create a new User"
      width={"400px"}
      onClose={onClose}
      visible={isOpen}
      bodyStyle={{ paddingBottom: 80 }}
    >
      <Form layout="vertical" onFinish={onSubmit}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="firstName"
              label="First Name"
              rules={[
                { required: true, message: "Please enter your first name" },
              ]}
            >
              <Input placeholder="Please enter your first name" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="lastName"
              label="Last Name"
              rules={[
                { required: true, message: "Please enter your last name" },
              ]}
            >
              <Input placeholder="Please enter your last name" />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="email"
              label="Email"
              rules={[
                { required: true, message: "Please enter your email" },
                { type: "email", message: "Please enter a valid email" },
              ]}
            >
              <Input placeholder="Please enter your email" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="userRole"
              label="User Role"
              rules={[
                { required: true, message: "Please choose the User Role" },
              ]}
            >
              <Select
                placeholder="Please choose the User Role"
                onChange={(role) => {
                  setShowStore(role === "store-user");
                }}
              >
                <Option value="store-user">Store User</Option>
                <Option value="delivery-user">Delivery User</Option>
                {/* <Option value="super-user">Super User</Option> */}
              </Select>
            </Form.Item>
          </Col>
        </Row>
        {canShowStore && (
          <Row gutter={16}>
            <Col span={24}>
              <Form.Item
                name="stores"
                label="Store"
                rules={[{ required: true, message: "Please select a store." }]}
              >
                <Select
                  showSearch
                  placeholder="Select the store"
                  optionFilterProp="children"
                  allowClear
                >
                  {stores.map((item: StoreType) => (
                    <Option value={item._id}>
                      <div
                        style={{
                          display: "flex",
                          justifyContent: "space-between",
                          alignItems: "center",
                        }}
                      >
                        {item.name}
                      </div>
                    </Option>
                  ))}
                </Select>
              </Form.Item>
            </Col>
          </Row>
        )}
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
