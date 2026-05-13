const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const User = require('./User');

const Book = sequelize.define('Book', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  author: {
    type: DataTypes.STRING,
    allowNull: false
  },
  sellingPrice: {
    type: DataTypes.FLOAT,
    allowNull: false
  },
  originalPrice: {
    type: DataTypes.FLOAT,
    allowNull: false
  },
  condition: {
    type: DataTypes.ENUM('Like New', 'Good', 'Old', 'Worn Out'),
    allowNull: false
  },
  tag: {
    type: DataTypes.STRING
  },
  description: {
    type: DataTypes.TEXT
  },
  images: {
    type: DataTypes.JSON, // Array of URLs
    defaultValue: []
  },
  isSold: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
});

// Associations
User.hasMany(Book, { foreignKey: 'sellerId', as: 'books', onDelete: 'CASCADE' });
Book.belongsTo(User, { foreignKey: 'sellerId', as: 'seller' });

module.exports = Book;
