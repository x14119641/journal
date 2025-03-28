import smtplib
import os
from pprint import pprint
from email.message import EmailMessage
import brevo_python
from brevo_python.rest import ApiException
import requests, json


def send_email(to_email: str, reset_link: str):
    url = "https://api.brevo.com/v3/smtp/email"
    me = "Jornolio"
    sender_email = "ecros4224@gmail.com"
    api_key = os.getenv("BREVO_API_KEY")
    payload = json.dumps(
        {
            "sender": {"name": me, "email":sender_email},
            "to": [{"email": f"{to_email}"}],
            "subject": "You requested a passoword resset",
            "textContent": f"The link: {reset_link}",
        }
    )
    headers = {
        "accept": "application/json",
        "api-key": api_key,
        "content-type": "application/json",
    }
    response = requests.request("POST", url, headers=headers, data=payload)
    print(response.text)
    

def send_reset_email(to_email: str, reset_link: str):
    sender_email = os.getenv("BREVO_SENDER", "ecros4224@gmail.com")
    html_content = f"""
    <html>
      <body style="font-family: Arial, sans-serif; color: #333;">
        <h2 style="color: #007bff;">Reset Your Password</h2>
        <p>Hello,</p>
        <p>You requested to reset your password. Click the button below to proceed:</p>
        <a href="{reset_link}" style="
          display: inline-block;
          padding: 12px 20px;
          margin: 10px 0;
          background-color: #007bff;
          color: white;
          text-decoration: none;
          border-radius: 4px;
        ">Reset Password</a>
        <p>If you didn’t request this, you can safely ignore this email.</p>
        <hr />
        <p style="font-size: 12px; color: #aaa;">This link will expire in 1 hour.</p>
      </body>
    </html>
    """

    payload = {
        "sender": {"name": "Jornolio 🚀", "email": sender_email},
        "to": [{"email": to_email}],
        "subject": "Reset Your Password",
        "htmlContent": html_content,
        "textContent": f"Reset your password here: {reset_link}"
    }

    headers = {
        "accept": "application/json",
        "api-key": os.getenv("BREVO_API_KEY"),
        "content-type": "application/json",
    }

    response = requests.post("https://api.brevo.com/v3/smtp/email", headers=headers, json=payload)
    # print('Resoponse: ', response)
    if response.status_code == 201:
        return {"message":"Email sent successfully"}
    else:
        return {"message":f"Failed to send email: {response.status_code} - {response.text}"}
    
    
def send_reset_eamil2(to_email: str, reset_link: str):
    configuration = brevo_python.Configuration()
    configuration.api_key['api-key'] = os.getenv("BREVO_API_KEY")

    api_instance = brevo_python.TransactionalEmailsApi(
        brevo_python.ApiClient(configuration))


    subject = "from the Python SDK!"
    sender = {"name": "Brevo", "email": "ecros4224@gmail.com"}
    replyTo = {"name": "Brevo", "email": "contact@brevo.com"}
    html_content = "<html><body><h1>This is my first transactional email </h1></body></html>"
    to = [{"email": to_email, "name": "Jane Doe"}]
    params = {"parameter": "My param value", "subject": "New Subject"}
    send_smtp_email = brevo_python.SendSmtpEmail(to=to, 
                                                # SendSmtpEmail | Values to send a transactional email
                                             html_content=html_content, sender=sender, subject=subject)

    try:
        # Send a transactional email
        api_response = api_instance.send_transac_email(send_smtp_email)
        pprint(api_response)
    except ApiException as e:
        print("Exception when calling TransactionalEmailsApi->send_transac_email: %s\n" % e)


def send_reset_eamil0(to_email: str, reset_link: str):
    msg = EmailMessage()
    msg["Subject"] = "Reset Your Password"
    me = "ecros4224@gmail.com"
    msg["From"] = me
    msg["To"] = to_email
    api_key =os.getenv("BREVO_API_KEY")

    # msg.set_content(f"Click the link to reset your password: {reset_link}")
    msg.set_content("Hello World")
    print('HERE: ', api_key)
    with smtplib.SMTP("smtp-relay.brevo.com", 587) as smtp:
        smtp.starttls()
        smtp.login(me, api_key)
        smtp.send_message(msg)
