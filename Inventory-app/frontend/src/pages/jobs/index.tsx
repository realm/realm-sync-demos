import React from "react";
import { PageProps } from "../../common/interfaces/PageProps";
import { JobList } from "./JobList";
import { PageHeader, Button } from "antd";
import { PlusOutlined } from "@ant-design/icons";
import { JobProvider } from "./context";
import { OneJob } from "./OneJob";
import { JobType } from "../../common/types/Jobs";
import { ProductProvider } from "../products/context";
import { StoreProvider } from "../stores/context";
import { UserProvider } from "../users/context";
import moment from "moment";
export interface JobPageProps extends PageProps {}

export const Jobs: React.FC<JobPageProps> = (_props: JobPageProps) => {
  const [openNew, setOpen] = React.useState(false);
  const [currentJob, setCurrentJob] = React.useState<JobType | null>(null);

  const returnExistingJob = (job:JobType | null) => {
    if(job){
      console.log(job)
      return {
        ...job,
        products: job.products.map((x)=>({...x.product, productName: x.product.name, transferQuantity: x.quantity})),
        assignedTo: job.assignedTo._id,
        sourceStore: job.sourceStore._id,
        destinationStore: job.destinationStore._id,
        pickupDatetime: moment(job.pickupDatetime),
      };
    }else {
      return null;
    }
    
  };


  return (
    <div>
      <ProductProvider>
        <StoreProvider>
          <UserProvider>
            <JobProvider>
              <PageHeader
                title="Jobs"
                subTitle="A master collection of all the products in the inventory."
                extra={[
                  <Button
                    type="primary"
                    onClick={() => {
                      setOpen(true);
                    }}
                  >
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
                <JobList
                  onEdit={(item: JobType) => {
                    setCurrentJob(item);
                    setOpen(true);
                  }}
                />
              </div>
              {openNew && (
                <OneJob
                  job={returnExistingJob(currentJob)}
                  isNew={currentJob === null}
                  onClose={() => {
                    setOpen(false);
                    setCurrentJob(null);
                  }}
                  isOpen
                />
              )}
            </JobProvider>
          </UserProvider>
        </StoreProvider>
      </ProductProvider>
    </div>
  );
};
