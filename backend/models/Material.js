const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const User = require('./User');

const Material = sequelize.define('Material', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  subject: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT
  },
  fileUrl: {
    type: DataTypes.STRING, // URL to PDF or Image
    allowNull: false
  },
  type: {
    type: DataTypes.ENUM('PDF', 'Image', 'Link'),
    defaultValue: 'PDF'
  }
});

User.hasMany(Material, { foreignKey: 'uploaderId', as: 'materials' });
Material.belongsTo(User, { foreignKey: 'uploaderId', as: 'uploader' });

module.exports = Material;
