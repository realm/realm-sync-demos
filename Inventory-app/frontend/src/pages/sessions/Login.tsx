import { Button, Col, Form, Input, Row } from "antd";
import React from "react";
import { useRealmApp } from "../../RealmApp";
import * as Realm from "realm-web";
export interface LoginProps {}

type LoginType = {
  email: string;
  password: string;
};

export const Login: React.FC<LoginProps> = (_props: LoginProps) => {
  const { logIn } = useRealmApp();
  const onFinish = (values: any) => {
    logIn(Realm.Credentials.emailPassword(values.email, values.password));
  };

  const onFinishFailed = (errorInfo: any) => {
    console.log("Failed:", errorInfo);
  };

  const [values]: [LoginType, any] = React.useState({
    email: "superuser@mailinator.com",
    password: "Qweasd123#",
  });

  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        height: "80vh",
      }}
    >
      <Form
        name="basic"
        layout="vertical"
        initialValues={values}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
      >
        <Row gutter={16}>
          <Col span={24}>
            <Form.Item
              label="Email"
              name="email"
              rules={[
                { required: true, message: "Please input your email" },
                { type: "email", message: "Enter a valid email" },
              ]}
            >
              <Input />
            </Form.Item>
          </Col>
          <Col span={24}>
            <Form.Item
              label="Password"
              name="password"
              rules={[
                { required: true, message: "Please input your password!" },
              ]}
            >
              <Input.Password />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item wrapperCol={{ offset: 8 }} style={{marginTop:20}}>
          <Button type="primary" htmlType="submit" style={{width:"120px", fontSize:14, fontWeight:900}}>
            Submit
          </Button>
        </Form.Item>
      </Form>
    </div>
  );
};
