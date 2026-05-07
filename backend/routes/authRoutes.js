const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const Book = require('../models/Book');
const { protect } = require('../middleware/auth');
const { upload } = require('../config/cloudinary');

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
      res.json({
        _id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
        college: user.college,
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

// @desc    Get current user profile
router.get('/profile', protect, async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ['password'] }
    });
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
        profileImage: updatedUser.profileImage,
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

module.exports = router;
