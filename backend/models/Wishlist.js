const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const User = require('./User');
const Book = require('./Book');

const Wishlist = sequelize.define('Wishlist', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  }
});

// Associations
User.hasMany(Wishlist, { foreignKey: 'userId', onDelete: 'CASCADE' });
Wishlist.belongsTo(User, { foreignKey: 'userId' });

Book.hasMany(Wishlist, { foreignKey: 'bookId', onDelete: 'CASCADE' });
Wishlist.belongsTo(Book, { foreignKey: 'bookId', as: 'book' });

module.exports = Wishlist;
