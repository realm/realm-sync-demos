import { UploadOutlined } from "@ant-design/icons";
import {
  Button,
  Col,
  Drawer,
  Form,
  Input,
  Row,
  Select,
  InputNumber,
  Upload,
  message,
} from "antd";
import React from "react";
import { handleRegularUpload } from "../../aws.config";
import { OneItemProps } from "../../common/interfaces/OneItemProps";
import { ProductType } from "../../common/types/Product";
import useUsers from "./context";

const { Option } = Select;

interface OneProductProps extends OneItemProps {
  isOpen: boolean;
  product: ProductType | null;
  onClose: () => void;
}

export const OneProduct: React.FC<OneProductProps> = ({
  isOpen,
  isNew,
  product,
  onClose,
}: OneProductProps) => {
  const {
    actions: { createOne, updateOne },
  } = useUsers();
  const onSubmit = (values: ProductType) => {
    values = {
      ...values,
      sku: values.sku.toString(),
      totalQuantity: values.totalQuantity.toString()
    }
    if (!isNew) {
      if (product) {
        updateOne(product._id, values, () => {
          onClose();
        });
      }
    } else {
      const { fileList }: any = values.image;
      if (fileList.length > 0) {
        const file = fileList[0];
        handleRegularUpload(
          file.originFileObj,
          { fileName: file.name, relativePath: "", maxSize: 2.5 },
          (err, data) => {
            if (err) {
              message.error("Error uploading the image.");
            } else {
              const { Location } = data;
              values = {
                ...values,
                sku: values.sku,
                totalQuantity: values.totalQuantity,
                _partition: "master",
                image: Location,
              };
              createOne(values, () => {
                onClose();
              });
            }
          }
        );
      } else {
        message.error("File not available to upload.");
      }
    }
  };

  return (
    <Drawer
      title={isNew ? "Create a new Product" : "Edit the Product"}
      width={"400px"}
      onClose={onClose}
      visible={isOpen}
      bodyStyle={{ paddingBottom: 80 }}
    >
      <Form
        layout="vertical"
        onFinish={onSubmit}
        initialValues={product as any}
      >
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="sku"
              label="SKU"
              rules={[{ required: true, message: "SKU is Required." }]}
            >
              <InputNumber
                style={{ width: "100%" }}
                placeholder="Please enter the SKU"
                disabled={!isNew}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="name"
              label="Name"
              rules={[
                { required: true, message: "Please enter the product name" },
              ]}
            >
              <Input placeholder="Product Name" />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={24}>
            <Form.Item
              name="detail"
              label="Description"
              rules={[
                { required: true, message: "Please enter the desciption" },
              ]}
            >
              <Input.TextArea placeholder="Description for the product." />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              name="price"
              label="Price Per Quantity"
              rules={[{ required: true, message: "Price is required." }]}
            >
              <InputNumber
                style={{ width: "100%" }}
                placeholder="Price per quantity"
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="totalQuantity"
              label="Total Quantity Available"
              rules={[
                {
                  required: true,
                  message: "Please enter the total quantity available.",
                },
              ]}
            >
              <InputNumber
                style={{ width: "100%" }}
                placeholder="Total quantity available"
              />
            </Form.Item>
          </Col>
          {isNew && (
            <Col span={12}>
              <Form.Item
                name="image"
                label="Upload Product Image"
                rules={[
                  {
                    required: true,
                    message: "Please upload the product image.",
                  },
                ]}
              >
                <Upload multiple={false} maxCount={1}>
                  {" "}
                  <Button icon={<UploadOutlined />}>Select File</Button>
                </Upload>
              </Form.Item>
            </Col>
          )}
        </Row>
        <Row gutter={16} style={{ marginTop: 20 }}>
          <Col span={24}>
            <Form.Item>
              <Button htmlType="button" type="text" onClick={onClose}>
                Close
              </Button>
              <Button type="primary" htmlType="submit" style={{width:"120px", fontSize:14, fontWeight:900}}>
                Submit
              </Button>
            </Form.Item>
          </Col>
        </Row>
      </Form>
    </Drawer>
  );
};
