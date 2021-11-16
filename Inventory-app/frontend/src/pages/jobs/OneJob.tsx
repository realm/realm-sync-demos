import { PlusOutlined } from "@ant-design/icons";
import {
  Button,
  Col,
  Drawer,
  Form,
  Input,
  Row,
  Select,
  InputNumber,
  DatePicker,
  Typography,
  Modal,
  Table,
} from "antd";
import moment from "moment";
import React from "react";
import { OneItemProps } from "../../common/interfaces/OneItemProps";
import { JobType } from "../../common/types/Jobs";
import { StoreInventoryTypes, StoreType } from "../../common/types/Store";
import { UserType } from "../../common/types/User";
import { useRealmApp } from "../../RealmApp";
import useStores from "../stores/context";
import useUsers from "../users/context";
import { AddProduct } from "./AddProduct";
import useJobs from "./context";

const { Option } = Select;
const { Title } = Typography;

interface OneJobProps extends OneItemProps {
  isOpen: boolean;
  job: any;
  onClose: () => void;
}

export const OneJob: React.FC<OneJobProps> = ({
  isOpen,
  isNew,
  job,
  onClose,
}: OneJobProps) => {
  const {
    state: { users },
  } = useUsers();
  const { profile } = useRealmApp();
  const {
    state: { stores, storeInventories },
    actions: { fetchAllStoreInventoriesWith, clearStoreAndInventory },
  } = useStores();
  const {
    actions: { createOne, updateOne },
  } = useJobs();
  const [addNew, setAddNew] = React.useState(false);
  const [productList, setProductList]: any = React.useState([]);
  const onSubmit = (values: JobType) => {
    let newJob: any = { _partition: "master", status: "to-do" };
    if (isNew) {
      const products: any = { create: [] };
      productList.map((x: any) => {
        products.create.push({
          product: {link:x.productId},
          quantity: x.transferQuantity.toString(),
          _partition: "master",
        });
      });
      newJob = {
        ...newJob,
        assignedTo: { link: values.assignedTo },
        sourceStore: { link: values.sourceStore },
        destinationStore: { link: values.destinationStore },
        pickupDatetime: values.pickupDatetime.toISOString(),
        createdBy: { link: profile._id },
        products,
      };
      createOne(newJob, () => {
        onClose();
      });
    } else {
      updateOne(job._id, { assignedTo: { link: values.assignedTo } }, () => {
        onClose();
      });
    }
  };

  React.useEffect(() => {
    console.log(job)
    if (job) {
      setProductList(job.products);
    } else {
      setProductList([]);
    }
  }, [job]);

  return (
    <Drawer
      title={isNew ? "Create a new Job" : "Edit the Job"}
      width={"500px"}
      onClose={onClose}
      visible={isOpen}
      bodyStyle={{ paddingBottom: 80 }}
    >
      <Form layout="vertical" onFinish={onSubmit} initialValues={job}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="sourceStore"
              label="Pickup Store"
              rules={[{ required: true, message: "Please select a store." }]}
            >
              <Select
                showSearch
                placeholder="Select the store"
                optionFilterProp="children"
                allowClear
                disabled={!isNew}
                onChange={(storeId: string) => {
                  if (storeId) {
                    fetchAllStoreInventoriesWith(storeId);
                  } else {
                    clearStoreAndInventory();
                  }
                }}
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
          <Col span={12}>
            <Form.Item
              name="destinationStore"
              label="Destination Store"
              rules={[{ required: true, message: "Please select a store." }]}
            >
              <Select
                showSearch
                disabled={!isNew}
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
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="pickupDatetime"
              label="Pickup Date and Time"
              rules={[
                { required: true, message: "Please enter the desciption" },
              ]}
            >
              <DatePicker
                disabled={!isNew}
                showTime
                style={{ width: "100%" }}
                showSecond={false}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="assignedTo"
              label="Assigned To"
              rules={[{ required: true, message: "Please select a store." }]}
            >
              <Select
                showSearch
                placeholder="Select the store"
                optionFilterProp="children"
                allowClear
                disabled={!isNew && (job.status!=="to-do")}
              >
                {users
                  .filter((x) => x.userRole === "delivery-user")
                  .map((item: UserType) => (
                    <Option value={item._id}>
                      <div
                        style={{
                          display: "flex",
                          justifyContent: "space-between",
                          alignItems: "center",
                        }}
                      >
                        {item.firstName} {item.lastName}
                      </div>
                    </Option>
                  ))}
              </Select>
            </Form.Item>
          </Col>
        </Row>
        <Row
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            marginTop: "20px",
          }}
        >
          <Title level={5} style={{ marginBottom: 0, paddingBottom: 0 }}>
            List of products to be added on the JOB.
          </Title>
          <Button
            type="link"
            disabled={!isNew}
            style={{ fontWeight: 900, float: "right" }}
            onClick={() => setAddNew(true)}
          >
            <PlusOutlined />
            Add New
          </Button>
        </Row>
        <Row style={{ width: "100%" }}>
          <Table
            style={{ width: "100%" }}
            dataSource={productList}
            columns={[
              {
                title: "Product Name",
                key: "productId",
                dataIndex: "productName",
              },
              {
                title: "Transfer Quantity",
                key: "transferQuantity",
                dataIndex: "transferQuantity",
              },
              {
                title: "Delete",
                render: (item) => {
                  return (
                    <Button
                      disabled={!isNew}
                      type="link"
                      onClick={() =>
                        setProductList(
                          productList.filter(
                            (x: any) => x.productId != item.productId
                          )
                        )
                      }
                    >
                      Delete
                    </Button>
                  );
                },
              },
            ]}
            pagination={false}
          ></Table>
        </Row>

        <Row gutter={16} style={{ marginTop: 50 }}>
          <Col span={12}>
            <Form.Item>
              <Button htmlType="button" type="text" onClick={onClose}>
                Close
              </Button>
              <Button
                type="primary"
                htmlType="submit"
                disabled={productList.length === 0}
              >
                Submit
              </Button>
            </Form.Item>
          </Col>
        </Row>
      </Form>

      {addNew && (
        <AddProduct
          onClose={() => setAddNew(false)}
          inventories={storeInventories}
          onSelected={(inventory: any) => {
            setProductList([...productList, inventory]);
            setAddNew(false);
          }}
        />
      )}
    </Drawer>
  );
};
