
import { Table, Typography } from "antd";
import React from "react";
import { ListProps } from "../../common/interfaces/ListProps";
import { useUsers } from "./context";
export interface UsersListProps extends ListProps {}

const {Paragraph}  = Typography;
const columns = [
  {
    title: "First Name",
    dataIndex: "firstName",
    key: "firstName",
  },
  {
    title: "Last Name",
    dataIndex: "lastName",
    key: "lastName",
  },
  {
    title: "Email",
    dataIndex: "email",
    key: "email",
  },
  {
    title: "Role",
    dataIndex: "userRole",
    key: "userRole",
  },
  {
    title: "Store",
    dataIndex: "stores",
    key: "stores",
    render: (item: any) => (
      <Paragraph style={{paddingLeft:30}}>{`${item? item.name:"All Stores"}`}</Paragraph>
    ),
  },
];

export const UserList: React.FC<UsersListProps> = (_props: UsersListProps) => {
  const {
    actions:{},
    state: { users },
  } = useUsers();
 
  return (
    <div>
      <Table dataSource={users} columns={columns} pagination={false} />
    </div>
  );
};
