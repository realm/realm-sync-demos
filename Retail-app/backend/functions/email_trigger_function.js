
exports = async function (changeEvent) {
  const { EMAIL_APP_API_KEY } = context.environment.values;
  const { WEBAPP_ENDPOINT } = context.environment.values;
  if (!EMAIL_APP_API_KEY) {
    return null;
  }

  // Access the latest version of the changed document
  // (with Full Document enabled for Insert, Update, and Replace operations):
  const fullDocument = changeEvent.fullDocument;
  const { status, type, order, assignedTo } = fullDocument;

  if (
    status === 'in-progress' &&
    (type === 'Installation' || type === 'Delivery')
  ) {
    // Access a mongodb service:
    const collection = context.services
      .get('mongodb-atlas')
      .db('sandbox')
      .collection('Orders');
    const orderInfo = await collection.findOne({ _id: order });
    if (orderInfo) {
      const { customerEmail, customerName, orderId, emailSent } = orderInfo;
      const link = `${WEBAPP_ENDPOINT}/${assignedTo}`
      if (!emailSent) {
        await collection.findOneAndUpdate({ _id: order },{$set:{emailSent:true}});
        const http = context.http;
        return http
          .post({
            headers: {
              'Content-Type': ['application/json'],
              Authorization: [`Bearer ${EMAIL_APP_API_KEY}`],
            },
            url: `https://api.sendgrid.com/v3/mail/send`,
            body: {
              personalizations: [{ to: [{ email: customerEmail }] }],
              from: { email: 'ramachandrang@wekancode.com' },
              subject: `Your live tracking link for the order no ${orderId}.`,
              content: [
                {
                  type: 'text/html',
                  value: `<div><h3>Hey ${customerName},</h3><br/><br/><p>Please find the tracking link to track the delivery person. ${link}</p></div>`,
                },
              ],
            },
            encodeBodyAsJSON: true,
          })
          .then((response) => {
            console.log(JSON.stringify(response))
            return EJSON.stringify({
              status: 'success',
              message: `Success email sending.${response.status}`,
            });
          })
          .catch((error) => {
            return EJSON.stringify({
              status: 'error',
              message: `Error in email sending.${error.message}`,
            });
          });
          
      }
      
    }
  }
};