const express = require('express');
const router = express.Router();
const Wishlist = require('../models/Wishlist');
const Book = require('../models/Book');
const User = require('../models/User');
const { protect } = require('../middleware/auth');

// @desc    Toggle Wishlist (Add/Remove)
// @route   POST /api/wishlist/:bookId
router.post('/:bookId', protect, async (req, res) => {
  try {
    const existing = await Wishlist.findOne({
      where: {
        userId: req.user.id,
        bookId: req.params.bookId
      }
    });

    if (existing) {
      await existing.destroy();
      return res.status(200).json({ saved: false, message: 'Removed from wishlist' });
    }

    await Wishlist.create({
      userId: req.user.id,
      bookId: req.params.bookId
    });

    res.status(201).json({ saved: true, message: 'Added to wishlist' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Get user wishlist
// @route   GET /api/wishlist
router.get('/', protect, async (req, res) => {
  try {
    const wishlist = await Wishlist.findAll({
      where: { userId: req.user.id },
      include: [{
        model: Book,
        as: 'book',
        include: [{ model: User, as: 'seller', attributes: ['username', 'email'] }]
      }]
    });

    // Extract only the books
    const books = wishlist.map(item => item.book).filter(book => book !== null);
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Check if book is in wishlist
// @route   GET /api/wishlist/check/:bookId
router.get('/check/:bookId', protect, async (req, res) => {
  try {
    const existing = await Wishlist.findOne({
      where: {
        userId: req.user.id,
        bookId: req.params.bookId
      }
    });
    res.json({ isSaved: !!existing });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
