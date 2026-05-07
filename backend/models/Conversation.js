const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const User = require('./User');
const Book = require('./Book');

const Conversation = sequelize.define('Conversation', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  // We'll use buyerId and sellerId as foreign keys
});

// Associations
Conversation.belongsTo(User, { as: 'buyer', foreignKey: 'buyerId' });
Conversation.belongsTo(User, { as: 'seller', foreignKey: 'sellerId' });
Conversation.belongsTo(Book, { as: 'book', foreignKey: 'bookId' });

module.exports = Conversation;
