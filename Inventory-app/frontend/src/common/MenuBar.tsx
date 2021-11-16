import React from "react";
import { Menu, Space } from "antd";
import { Link, useLocation } from "react-router-dom";
import { useRealmApp } from "../RealmApp";
import {
  BarcodeOutlined,
  UsergroupAddOutlined,
  ShopOutlined,
  RocketOutlined,
} from "@ant-design/icons";

interface MenuBarProps {}

export const MenuBar: React.FC<MenuBarProps> = (_props: MenuBarProps) => {
  const { pathname } = useLocation();
  const { currentUser } = useRealmApp();
  if(!currentUser){
    return null;
  }
  return (
    <div
      style={{
        width: "100%",
        margin: "0 auto",
        textAlign: "center",
        backgroundColor: "white",
      }}
    >
      <Space>
        <Menu onClick={() => {}} selectedKeys={[pathname]} mode="horizontal">
          <Menu.Item key="/jobs" icon={<RocketOutlined />}>
            <Link to="/jobs">Jobs</Link>
          </Menu.Item>
          <Menu.Item key="/products" icon={<BarcodeOutlined />}>
            <Link to="/products">Products</Link>
          </Menu.Item>
          <Menu.Item key="/stores" icon={<ShopOutlined />}>
            <Link to="/stores">Stores</Link>
          </Menu.Item>
          <Menu.Item key="/users" icon={<UsergroupAddOutlined />}>
            <Link to="/users">Users</Link>
          </Menu.Item>
        </Menu>
      </Space>
    </div>
  );
};
