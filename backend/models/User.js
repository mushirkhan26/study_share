const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');
const bcrypt = require('bcryptjs');

const User = sequelize.define('User', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  username: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  },
  role: {
    type: DataTypes.ENUM('buyer', 'seller'),
    defaultValue: 'buyer'
  },
  college: {
    type: DataTypes.STRING
  },
  profileImage: {
    type: DataTypes.STRING
  },
  phoneNumber: {
    type: DataTypes.STRING,
    allowNull: true
  },
  isTwoFactorEnabled: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  isPrivateProfile: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  showPhoneNumber: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  otp: {
    type: DataTypes.STRING,
    allowNull: true
  },
  otpExpires: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  hooks: {
    beforeCreate: async (user) => {
      user.password = await bcrypt.hash(user.password, 10);
    },
    beforeUpdate: async (user) => {
      if (user.changed('password')) {
        user.password = await bcrypt.hash(user.password, 10);
      }
    }
  }
});

User.prototype.comparePassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

module.exports = User;
