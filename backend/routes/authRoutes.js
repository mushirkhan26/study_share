const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const Book = require('../models/Book');
const Session = require('../models/Session');
const { protect } = require('../middleware/auth');
const { upload } = require('../config/cloudinary');
const { sendOTP } = require('../config/email');

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });
};

// @desc    Register new user
router.post('/signup', async (req, res) => {
  const { username, email, password, role, college } = req.body;

  try {
    const userExists = await User.findOne({ where: { email } });
    if (userExists) return res.status(400).json({ message: 'User already exists' });

    const user = await User.create({ username, email, password, role, college });

    // Create a session
    await Session.create({
      userId: user.id,
      deviceName: req.headers['user-agent'] || 'Unknown Device',
      ipAddress: req.ip
    });

    res.status(201).json({
      _id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      token: generateToken(user.id),
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Login user
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (user && (await user.comparePassword(password))) {

      // Check if 2FA is enabled
      if (user.isTwoFactorEnabled) {
        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otpExpires = new Date(Date.now() + 10 * 60 * 1000); // 10 mins

        user.otp = otp;
        user.otpExpires = otpExpires;
        await user.save();

        const emailSent = await sendOTP(user.email, otp);
        if (!emailSent) {
          return res.status(500).json({ message: 'Failed to send OTP email' });
        }

        return res.json({
          requires2FA: true,
          email: user.email,
          message: 'OTP sent to your email'
        });
      }

      // If no 2FA, proceed with normal login
      await Session.create({
        userId: user.id,
        deviceName: req.headers['user-agent'] || 'Unknown Device',
        ipAddress: req.ip
      });

      res.json({
        _id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
        college: user.college,
        phoneNumber: user.phoneNumber,
        profileImage: user.profileImage,
        token: generateToken(user.id),
      });
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Verify OTP for 2FA
router.post('/verify-2fa', async (req, res) => {
  const { email, otp } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (!user || user.otp !== otp || user.otpExpires < new Date()) {
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    // Clear OTP after successful verification but KEEP 2FA status
    user.otp = null;
    user.otpExpires = null;
    await user.save();

    // Create session
    await Session.create({
      userId: user.id,
      deviceName: req.headers['user-agent'] || 'Unknown Device',
      ipAddress: req.ip
    });

    res.json({
      _id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      college: user.college,
      profileImage: user.profileImage,
      isTwoFactorEnabled: user.isTwoFactorEnabled,
      isPrivateProfile: user.isPrivateProfile,
      showPhoneNumber: user.showPhoneNumber,
      token: generateToken(user.id),
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Get current user profile
router.get('/profile', protect, async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ['password'] }
    });

    // Ensure a session exists for the current device if it's a new login/fresh check
    const existingSession = await Session.findOne({
      where: {
        userId: req.user.id,
        deviceName: req.headers['user-agent'] || 'Unknown Device'
      }
    });

    if (!existingSession) {
      await Session.create({
        userId: req.user.id,
        deviceName: req.headers['user-agent'] || 'Unknown Device',
        ipAddress: req.ip
      });
    } else {
      // Update last active
      existingSession.lastActive = new Date();
      await existingSession.save();
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Update user profile
router.put('/profile', protect, upload.single('profileImage'), async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id);

    if (user) {
      user.username = req.body.username || user.username;
      user.college = req.body.college || user.college;
      user.phoneNumber = req.body.phoneNumber || user.phoneNumber;
      user.role = req.body.role || user.role;

      if (req.file) {
        user.profileImage = req.file.path; // Cloudinary URL
      }

      const updatedUser = await user.save();

      res.json({
        _id: updatedUser.id,
        username: updatedUser.username,
        email: updatedUser.email,
        role: updatedUser.role,
        college: updatedUser.college,
        phoneNumber: updatedUser.phoneNumber,
        profileImage: updatedUser.profileImage,
        isTwoFactorEnabled: updatedUser.isTwoFactorEnabled,
        isPrivateProfile: updatedUser.isPrivateProfile,
        showPhoneNumber: updatedUser.showPhoneNumber,
      });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Get user stats
router.get('/stats', protect, async (req, res) => {
  try {
    const activeAds = await Book.count({
      where: { sellerId: req.user.id, isSold: false }
    });
    const booksSold = await Book.count({
      where: { sellerId: req.user.id, isSold: true }
    });

    // Calculate total earnings
    const books = await Book.findAll({
      where: { sellerId: req.user.id, isSold: true },
      attributes: ['sellingPrice']
    });
    const earnings = books.reduce((sum, book) => sum + book.sellingPrice, 0);

    res.json({
      activeAds,
      booksSold,
      earnings
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Change password
router.put('/change-password', protect, async (req, res) => {
  const { oldPassword, newPassword } = req.body;

  try {
    const user = await User.findByPk(req.user.id);
    if (user && (await user.comparePassword(oldPassword))) {
      user.password = newPassword;
      await user.save();
      res.json({ message: 'Password updated successfully' });
    } else {
      res.status(401).json({ message: 'Invalid old password' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Update privacy/security settings
router.put('/settings', protect, async (req, res) => {
  const { isTwoFactorEnabled, isPrivateProfile, showPhoneNumber } = req.body;

  try {
    const user = await User.findByPk(req.user.id);
    if (user) {
      if (isTwoFactorEnabled !== undefined) user.isTwoFactorEnabled = isTwoFactorEnabled;
      if (isPrivateProfile !== undefined) user.isPrivateProfile = isPrivateProfile;
      if (showPhoneNumber !== undefined) user.showPhoneNumber = showPhoneNumber;

      await user.save();
      res.json({
        message: 'Settings updated successfully',
        settings: {
          isTwoFactorEnabled: user.isTwoFactorEnabled,
          isPrivateProfile: user.isPrivateProfile,
          showPhoneNumber: user.showPhoneNumber
        }
      });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Get active sessions
router.get('/sessions', protect, async (req, res) => {
  try {
    const sessions = await Session.findAll({
      where: { userId: req.user.id },
      order: [['lastActive', 'DESC']]
    });
    res.json(sessions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Revoke session
router.delete('/sessions/:id', protect, async (req, res) => {
  try {
    const session = await Session.findOne({
      where: { id: req.params.id, userId: req.user.id }
    });

    if (session) {
      await session.destroy();
      res.json({ message: 'Session revoked successfully' });
    } else {
      res.status(404).json({ message: 'Session not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Delete account
router.delete('/account', protect, async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id);
    if (user) {
      // With CASCADE, this will delete everything related to the user
      await user.destroy();
      res.json({ message: 'Account and all related data deleted successfully' });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    console.error('Account deletion error:', error);
    res.status(500).json({ message: error.message });
  }
});

// @desc    Request password reset OTP
router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'User with this email not found' });
    }

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpExpires = new Date(Date.now() + 10 * 60 * 1000); // 10 mins

    user.otp = otp;
    user.otpExpires = otpExpires;
    await user.save();

    const emailSent = await sendOTP(user.email, otp);
    if (!emailSent) {
      return res.status(500).json({ message: 'Failed to send OTP email' });
    }

    res.json({ message: 'OTP sent to your email' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Reset password using OTP
router.post('/reset-password', async (req, res) => {
  const { email, otp, newPassword } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (!user || user.otp !== otp || user.otpExpires < new Date()) {
      return res.status(401).json({ message: 'Invalid or expired OTP' });
    }

    user.password = newPassword;
    user.otp = null;
    user.otpExpires = null;
    await user.save();

    res.json({ message: 'Password reset successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
