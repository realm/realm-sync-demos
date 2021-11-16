exports = async function (arg) {
  const { firstName, lastName, email, password } = arg;

  const { EMAIL_APP_API_KEY } = context.environment.values;
  const http = context.services.get("realm-http");
  if (!EMAIL_APP_API_KEY) {
    return null;
  }

  return http
    .post({
      headers: {
        "Content-Type": ["application/json"],
        Authorization: [
          `Bearer ${EMAIL_APP_API_KEY}`,
        ],
      },
      url: `https://api.sendgrid.com/v3/mail/send`,
      body: {
        personalizations: [{ to: [{ email: email }] }],
        from: { email: "ramachandrang@wekancode.com" },
        subject: "Your Account has been created successfully.",
        content: [
          {
            type: "text/html",
            value: `<div><h3>Hey ${firstName},</h3><br/><br/><p> Your account with Phase 1 ECommerce Realm App is created successfully, please find the credentials to login to the application.</p><br/><br/><p>Email: <strong>${email}</strong><br/>Password: <strong>${password}</strong></p></div>`,
          },
        ],
      },
      encodeBodyAsJSON: true,
    })
    .then((response) => {
      return EJSON.stringify({status:"success", message:`Success email sending.${response.status}`})
    })
    .catch((error) =>{
      return EJSON.stringify({status:"error", message:`Error in email sending.${error.message}`})
    });
};
