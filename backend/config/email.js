const { Resend } = require('resend');
require('dotenv').config();

// Use the API key from .env or fallback for testing (but primarily .env)
const resend = new Resend(process.env.RESEND_API_KEY);

const sendOTP = async (email, otp) => {
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
