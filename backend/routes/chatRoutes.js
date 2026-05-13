const express = require('express');
const router = express.Router();
const Conversation = require('../models/Conversation');
const Message = require('../models/Message');
const User = require('../models/User');
const Book = require('../models/Book');
const { protect } = require('../middleware/auth');
const { Op } = require('sequelize');

// @desc    Get or Create Conversation
// @route   POST /api/chat/conversation
router.post('/conversation', protect, async (req, res) => {
  const { sellerId, bookId } = req.body;
  const buyerId = req.user.id;

  if (sellerId === buyerId) {
    return res.status(400).json({ message: "You cannot chat with yourself" });
  }

  try {
    let conversation = await Conversation.findOne({
      where: { buyerId, sellerId, bookId }
    });

    if (!conversation) {
      conversation = await Conversation.create({ buyerId, sellerId, bookId });
    }

    res.status(200).json(conversation);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Get all conversations for user
// @route   GET /api/chat/conversations
router.get('/conversations', protect, async (req, res) => {
  try {
    const conversations = await Conversation.findAll({
      where: {
        [Op.or]: [{ buyerId: req.user.id }, { sellerId: req.user.id }]
      },
      include: [
        { model: User, as: 'buyer', attributes: ['id', 'username'] },
        { model: User, as: 'seller', attributes: ['id', 'username'] },
        { model: Book, as: 'book', attributes: ['id', 'title', 'images', 'sellingPrice'] }
      ],
      order: [['updatedAt', 'DESC']]
    });
    res.json(conversations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Get messages for a conversation
// @route   GET /api/chat/messages/:conversationId
router.get('/messages/:conversationId', protect, async (req, res) => {
  try {
    const messages = await Message.findAll({
      where: { conversationId: req.params.conversationId },
      order: [['createdAt', 'ASC']]
    });
    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Mark messages as read
// @route   PUT /api/chat/messages/:conversationId/read
router.put('/messages/:conversationId/read', protect, async (req, res) => {
  try {
    await Message.update(
      { isRead: true },
      {
        where: {
          conversationId: req.params.conversationId,
          senderId: { [Op.ne]: req.user.id },
          isRead: false
        }
      }
    );
    res.status(200).json({ message: 'Messages marked as read' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// @desc    Send a message (HTTP Fallback)
// @route   POST /api/chat/message
router.post('/message', protect, async (req, res) => {
  const { conversationId, text } = req.body;
  const senderId = req.user.id;

  try {
    const newMessage = await Message.create({
      conversationId,
      senderId,
      text
    });

    // Update conversation timestamp
    await Conversation.update({ updatedAt: new Date() }, { where: { id: conversationId } });

    res.status(201).json(newMessage);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
