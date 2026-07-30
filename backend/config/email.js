const { Resend } = require('resend');
require('dotenv').config();

// Use the API key from .env
const resendApiKey = process.env.RESEND_API_KEY;

// Safely initialize Resend only if API key exists and is valid to prevent server crash
let resend = null;
if (resendApiKey && resendApiKey !== 're_dummy_key' && resendApiKey.trim() !== "") {
  try {
    resend = new Resend(resendApiKey);
  } catch (error) {
    console.error('Failed to initialize Resend:', error.message);
  }
} else {
  console.warn('RESEND_API_KEY is missing or invalid. Email features will be disabled.');
}

const sendOTP = async (email, otp) => {
  if (!resend) {
    console.warn('Cannot send email: Resend is not configured.');
    console.log(`[DEV MODE] OTP for ${email} is: ${otp}`);
    return true;
  }

  try {
    const { data, error } = await resend.emails.send({
      from: 'StudyShare <onboarding@resend.dev>',
      to: email,
      subject: 'StudyShare - Your Login OTP',
      html: `
        <div style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
          <h2>Welcome to StudyShare!</h2>
          <p>Your OTP for logging in is:</p>
          <h1 style="color: #00BFA5; letter-spacing: 5px;">${otp}</h1>
          <p>This code will expire in 10 minutes.</p>
          <p>If you didn't request this, please ignore this email.</p>
        </div>
      `,
    });

    if (error) {
      console.error('Resend Error:', error);
      return false;
    }

    console.log(`OTP sent successfully to ${email}. ID: ${data.id}`);
    return true;
  } catch (error) {
    console.error('Error sending email via Resend:', error);
    return false;
  }
};

module.exports = { sendOTP };
