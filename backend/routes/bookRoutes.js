const express = require('express');
const router = express.Router();
const Book = require('../models/Book');
const User = require('../models/User');
const { protect, authorize } = require('../middleware/auth');
const { upload } = require('../config/cloudinary');
const { Op } = require('sequelize');

// @desc    Get all books (With Search and Filters)
router.get('/', async (req, res) => {
  try {
    const { search, tag, condition } = req.query;

    let query = {
      where: { isSold: false },
      include: [{ model: User, as: 'seller', attributes: ['id', 'username', 'email'] }],
      order: [['createdAt', 'DESC']]
    };

    // If search term is provided
    if (search) {
      query.where[Op.or] = [
        { title: { [Op.iLike]: `%${search}%` } },
        { author: { [Op.iLike]: `%${search}%` } },
        { tag: { [Op.iLike]: `%${search}%` } },
      ];
    }

    // If specific tag filter is provided
    if (tag && tag !== 'All') {
      query.where.tag = tag;
    }

    // If specific condition filter is provided
    if (condition && condition !== 'All') {
      query.where.condition = condition;
    }

    const books = await Book.findAll(query);
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Post a new book (Sellers only)
// Note: Use upload.single('image') to handle the book photo
router.post('/', protect, authorize('seller'), upload.single('image'), async (req, res) => {
  console.log('--- BOOK UPLOAD REQUEST START ---');
  console.log('Body:', req.body);
  console.log('File:', req.file ? req.file.path : 'No file uploaded');

  const { title, author, sellingPrice, originalPrice, condition, tag, description } = req.body;

  try {
    // If image was uploaded, req.file will have the Cloudinary URL
    const imageUrl = req.file ? req.file.path : null;

    const book = await Book.create({
      title,
      author,
      sellingPrice,
      originalPrice,
      condition,
      tag,
      description,
      images: imageUrl ? [imageUrl] : [],
      sellerId: req.user.id,
    });
    console.log('Book created successfully:', book.id);
    res.status(201).json(book);
  } catch (error) {
    console.error('Book creation error:', error.message);
    res.status(500).json({ message: error.message });
  }
});

// @desc    Get my books (Current Seller)
router.get('/my-ads', protect, authorize('seller'), async (req, res) => {
  try {
    const books = await Book.findAll({
      where: { sellerId: req.user.id },
      order: [['createdAt', 'DESC']]
    });
    res.json(books);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Update book status (Mark as Sold)
router.put('/:id/status', protect, authorize('seller'), async (req, res) => {
  try {
    const book = await Book.findOne({ where: { id: req.params.id, sellerId: req.user.id } });
    if (!book) return res.status(404).json({ message: 'Book not found or unauthorized' });

    book.isSold = req.body.isSold;
    await book.save();
    res.json(book);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Delete a book ad
router.delete('/:id', protect, authorize('seller'), async (req, res) => {
  try {
    const book = await Book.findOne({ where: { id: req.params.id, sellerId: req.user.id } });
    if (!book) return res.status(404).json({ message: 'Book not found or unauthorized' });

    await book.destroy();
    res.json({ message: 'Book ad deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
