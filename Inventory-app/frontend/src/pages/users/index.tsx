import React from "react";
import { PageProps } from "../../common/interfaces/PageProps";
import { UserList } from "./UsersList";
import { PlusOutlined } from "@ant-design/icons";
import { Button, PageHeader } from "antd";
import { UserProvider } from "./context";
import { OneUser } from "./OneUser";
import { StoreProvider } from "../stores/context";
import { ProductProvider } from "../products/context";

export interface UsersPageProps extends PageProps {}

export const Users: React.FC<UsersPageProps> = (_props: UsersPageProps) => {
  const [openNew, setOpen] = React.useState(false);
  const [currentUser, setCurrentUser] = React.useState(null);
  return (
    <div>
      <ProductProvider>
        <StoreProvider>
          <UserProvider>
            <PageHeader
              title="Users"
              subTitle="A master collection of all the users in the platform."
              extra={[
                <Button type="primary" onClick={() => setOpen(true)}>
                  <PlusOutlined /> Add New
                </Button>,
              ]}
            />
            <div
              style={{
                padding: "20px",
                minHeight: "100%",
                height: "max-content",
              }}
            >
              <UserList />
            </div>
            {openNew && (
              <OneUser
                user={currentUser}
                isNew={currentUser === null}
                onClose={() => setOpen(false)}
                isOpen
              />
            )}
          </UserProvider>
        </StoreProvider>
      </ProductProvider>
    </div>
  );
};
