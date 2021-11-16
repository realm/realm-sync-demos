import { message } from "antd";
import * as AWS from "aws-sdk";

const AWSService = AWS;

const { REACT_APP_S3_BUCKET, REACT_APP_AWS_IDENTITY_POOL_ID, REACT_APP_S3_REGION }: any = process.env;


type FileOptions = {
  maxSize?: number;
  fileName: string;
  relativePath: string;
};


AWSService.config.update({
  region: REACT_APP_S3_REGION,
  credentials: new AWSService.CognitoIdentityCredentials({
    IdentityPoolId: REACT_APP_AWS_IDENTITY_POOL_ID,
  }),
});

const S3 = new AWSService.S3({
  params: { Bucket: REACT_APP_S3_BUCKET },
});

export const getExtension = (fileName: string) => fileName.split('.').pop();


export const randomString = (length: number) => {
  var result = '';
  var characters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var charactersLength = characters.length;
  for (var i = 0; i < length; i++) {
    result += characters?.charAt(
      Math.floor(Math.random() * charactersLength)
    );
  }
  return result;
};

export const handleRegularUpload = async (
  file: any,
  fileOptions: FileOptions,
  callback?: (err: any, res: any) => void
) => {
  return new Promise((resolve, reject) => {
    if (!file) {
      if (typeof callback === 'function') {
        callback(new Error(`File not found.`), null);
        reject(new Error(`File not found.`));
      }
      return;
    }

    const { size, name }: any = file;
    let maxSize = fileOptions.maxSize ? fileOptions.maxSize : 2.5;
    if (size / 1024 / 1024 < maxSize) {
      message.loading("Uploading....");
      S3.upload(
        {
          Key: `${fileOptions.relativePath}${randomString(10)
            }.${getExtension(name)}`,
          Bucket: process.env.REACT_APP_S3_BUCKET || '',
          Body: file,
          ACL: 'public-read',
          ContentType: file.type,
        },
        function (err: any, data: any) {
          if (err) {
            message.error(err.message);
            reject(err.message);
          }
          if (typeof callback === 'function') {
            callback(err, data);
            resolve(data);
          }else{
            resolve(data);
          }
        }
      );
    } else {
      message.error(`File cant be bigger than ${maxSize}mb.`);
      if (typeof callback === 'function') {
        callback(
          new Error(`File cant be bigger than ${maxSize}mb.`),
          null
        );
      }
      reject(`File cant be bigger than ${maxSize}mb.`);
    }
  });
};

export default S3;




