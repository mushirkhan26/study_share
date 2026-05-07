const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const { connectDB } = require('./config/db');
const morgan = require('morgan');
const http = require('http');
const { Server } = require('socket.io');

// Load env vars
dotenv.config();

// Connect to PostgreSQL
connectDB();

// Route imports
const authRoutes = require('./routes/authRoutes');
const bookRoutes = require('./routes/bookRoutes');
const chatRoutes = require('./routes/chatRoutes');
const wishlistRoutes = require('./routes/wishlistRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const materialRoutes = require('./routes/materialRoutes');

// Initialize express
const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

app.use(morgan('common'));

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/books', bookRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/wishlist', wishlistRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/materials', materialRoutes);

app.get('/', (req, res) => {
  res.send('StudyShare PostgreSQL API is running...');
});

// Socket.io Logic
io.on('connection', (socket) => {
  console.log('A user connected:', socket.id);

  socket.on('join_chat', (conversationId) => {
    socket.join(conversationId);
    console.log(`User joined chat: ${conversationId}`);
  });

  socket.on('send_message', async (data) => {
    const { conversationId, senderId, text } = data;
    try {
      const Message = require('./models/Message');
      const Conversation = require('./models/Conversation');
      const Notification = require('./models/Notification');
      const User = require('./models/User');

      const newMessage = await Message.create({
        conversationId,
        senderId,
        text
      });

      // Update conversation timestamp
      await Conversation.update({ updatedAt: new Date() }, { where: { id: conversationId } });

      // Find recipient
      const conv = await Conversation.findByPk(conversationId);
      const recipientId = conv.buyerId === senderId ? conv.sellerId : conv.buyerId;
      const sender = await User.findByPk(senderId);

      // Create notification
      await Notification.create({
        userId: recipientId,
        title: 'New Message 💬',
        message: `${sender.username} sent you a message: ${text.substring(0, 50)}${text.length > 50 ? '...' : ''}`,
        type: 'message'
      });

      io.to(conversationId).emit('receive_message', newMessage);
    } catch (error) {
      console.error('Error sending message:', error);
    }
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));
