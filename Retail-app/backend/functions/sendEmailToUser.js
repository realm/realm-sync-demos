exports = async function (arg) {
  const axios = require("axios");
  
  const { firstName, lastName, email, password } = arg;
  const { EMAIL_APP_API_KEY } = context.environment.values;

  if (!EMAIL_APP_API_KEY) {
    return null;
  }

  const body = {
    personalizations: [{ to: [{ email: email }] }],
    from: { name: 'Ramachandran G', email: 'ramachandrang@wekancode.com' },
    subject: 'Your Account has been created successfully.',
    content: [
      {
        type: 'text/html',
        value: `<div><h3>Hey ${firstName},</h3><br/><br/><p> Your account with Phase 2 ECommerce Realm App is created successfully, please find the credentials to login to the application.</p><br/><br/><p>Email: <strong>${email}</strong><br/>Password: <strong>${password}</strong></p></div>`,
      },
    ],
  };
  
  const config = {
    method: 'post',
    url: 'https://api.sendgrid.com/v3/mail/send',
    headers: {
      Authorization: `Bearer ${EMAIL_APP_API_KEY}`,
      'Content-Type': 'application/json',
    },
    data: body,
  };
  
  return axios(config)
    .then(function (response) {
      return EJSON.stringify({
        status: 'success',
        message: `Success email sending.${response.status}`,
      });
    })
    .catch(function (error) {
      console.log(error);
      return EJSON.stringify({
        status: 'error',
        message: `Error in email sending.${error.message}`,
      });
    });
};
