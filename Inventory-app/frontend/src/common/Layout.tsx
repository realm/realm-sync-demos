import { Image, Typography, Layout, Dropdown, Menu, Popconfirm } from "antd";
import { CaretDownOutlined } from "@ant-design/icons";
import React from "react";
import { useRealmApp } from "../RealmApp";

const { Text } = Typography;
const { Header, Content, Footer } = Layout;
export interface LayoutProps {
  children: React.ReactNode;
}

export const LayoutContainer: React.FC<LayoutProps> = ({
  children,
}: LayoutProps) => {
  const { currentUser, profile, logOut } = useRealmApp();
  return (
    <Layout
      style={{
        display: "grid",
        gridTemplateRows: "auto 1fr",
        width: "100%",
        height: "100vh",
      }}
    >
      <Header
        style={{
          backgroundColor: "white",
          borderBottom: "1px solid rgb(231, 238, 236)",
          color: "black",
          display: "flex",
          alignItems: "center",
          justifyContent: "flex-end",
          position: 'relative'
        }}
      >
        <div style={{position:'absolute', display:'flex', width:'100%', height:'100%', justifyContent:"center", alignItems:"center"}}> <Image
          preview={false}
          width={120}
          src="https://www.wekanenterprisesolutions.com/images/wekan-logo.svg"
        /></div>
        {currentUser && (
          <Dropdown.Button
            onClick={() => {}}
            buttonsRender={([left]) => [
              left,
              <CaretDownOutlined
                style={{
                  display: "flex",
                  alignItems: "center",
                  padding: "0px 10px",
                  border: "1px solid #d9d9d9",
                  cursor: "pointer",
                }}
              />,
            ]}
            overlay={
              <Menu onClick={() => {}}>
                <Menu.Item key="1">
                  {" "}
                  <Popconfirm
                    title="Are you sure want to logout?"
                    onConfirm={() => {
                      logOut();
                    }}
                    onCancel={() => {}}
                    okText="Yes"
                    cancelText="No"
                  >
                    Logout
                  </Popconfirm>
                </Menu.Item>
              </Menu>
            }
          >
            <Text strong>
              {profile ? `${profile.firstName} ${profile.lastName}` : "N/A"}
            </Text>
          </Dropdown.Button>
        )}
      </Header>
      <Layout style={{ minHeight: "100%" }}>
        <Content style={{ height: "inherit" }}>{children}</Content>
      </Layout>
      {/* <Footer style={{ borderTop: "1px solid rgb(231, 238, 236)" }}>
        <Text style={{ float: "right" }} strong>
          MongoDB Realm
        </Text>
      </Footer> */}
    </Layout>
  );
};
