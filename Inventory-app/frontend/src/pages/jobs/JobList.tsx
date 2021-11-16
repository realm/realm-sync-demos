import { ExclamationCircleOutlined } from "@ant-design/icons";
import { Button, Table, Typography, Modal, Select, message } from "antd";
import moment from "moment";
import React from "react";
import { ListProps } from "../../common/interfaces/ListProps";
import { JobType } from "../../common/types/Jobs";
import useJobs from "./context";
const { confirm } = Modal;
const { Paragraph, Title } = Typography;
const { Option } = Select;

export interface JobListProps extends ListProps {
  onEdit: (item: JobType) => void;
}

export const JobList: React.FC<JobListProps> = ({ onEdit }: JobListProps) => {
  const {
    actions: { updateOne },
    state: { jobs },
  } = useJobs();

  const updateStatus = (jobId: string, status: string) => {
    confirm({
      title: "Do you want to change the status?",
      icon: <ExclamationCircleOutlined />,
      onOk() {
        message.loading({ content: "Updating...", key: "loading" });
        updateOne(jobId, { status }, () => {});
      },
      onCancel() {},
    });
  };

  const columns = [
    {
      title: "Job Id",
      dataIndex: "_id",
      key: "_id",
      width:"14.2%"
    },
    {
      title: "Created By",
      key: "createdBy",
      width:"24%",
      render: (item: JobType) => (
        <div>
          <Title level={5}>
            {`${item.createdBy.firstName} ${item.createdBy.lastName}`}
          </Title>
          <Paragraph>
            Source Store: <strong>{item.sourceStore.name}</strong> <br></br>
            Destination Store: <strong>{item.destinationStore.name}</strong>
          </Paragraph>
        </div>
      ),
    },
    {
      title: "Assigned To",
      key: "assignedTo",
      width:"14.2%",
      render: (item: JobType) => (
        <Paragraph>
          {`${item.assignedTo.firstName} ${item.assignedTo.lastName}`}
        </Paragraph>
      ),
    },
    {
      title: "Pickup Date & Time",
      key: "price",
      width:"14.2%",
      render: (item: JobType) => (
        <Paragraph>{`${moment(item.pickupDatetime).format(
          "YYYY MMM DD, HH:mm"
        )}`}</Paragraph>
      ),
    },
    {
      title: "Total Products",
      key: "totalProducts",
      width:"14.2%",
      render: (item: JobType) => (
        <Paragraph style={{paddingLeft:30}}>{`${item.products.length}`}</Paragraph>
      ),
    },
    {
      title: "Status",
      key: "status",
      width:"14.2%",
      render: (item: JobType) => (
        <Select
          value={item.status}
          style={{ width: 120 }}
          onChange={(status) => updateStatus(item._id, status)}
        >
          <Option
            value="to-do"
            disabled={item.status === "in-progress" || item.status === "done"}
          >
            To Do
          </Option>
          <Option value="in-progress"  disabled={item.status === "done"}>In Progress</Option>
          <Option value="done"  disabled={item.status === "to-do"}>Done</Option>
        </Select>
      ),
    },
    {
      title: "Action",
      key: "action",
      width:"14.2%",
      render: (item: JobType) => (
        <Button type="ghost" onClick={() => onEdit(item)}>
          Edit
        </Button>
      ),
    },
  ];
  return (
    <div>
      <Table dataSource={jobs} columns={columns} pagination={false} />
    </div>
  );
};
