const express = require('express');
const router = express.Router();
const Material = require('../models/Material');
const User = require('../models/User');
const { protect } = require('../middleware/auth');
const { upload } = require('../config/cloudinary');

// @desc    Get all materials
router.get('/', async (req, res) => {
  try {
    const materials = await Material.findAll({
      include: [{ model: User, as: 'uploader', attributes: ['username', 'college'] }],
      order: [['createdAt', 'DESC']]
    });
    res.json(materials);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Upload new material
router.post('/', protect, upload.single('file'), async (req, res) => {
  const { title, subject, description, type } = req.body;
  try {
    const fileUrl = req.file ? req.file.path : null;
    if (!fileUrl) return res.status(400).json({ message: 'File is required' });

    const material = await Material.create({
      title,
      subject,
      description,
      type,
      fileUrl,
      uploaderId: req.user.id
    });
    res.status(201).json(material);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
