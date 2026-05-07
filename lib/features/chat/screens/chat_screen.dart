import 'package:flutter/material.dart';
import '../../../core/api/network/chat_service.dart';
import '../../../core/api/network/socket_service.dart';
import '../../../core/services/secure_storage_service.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? bookData;

  const ChatScreen({
    super.key,
    this.bookData,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();
  final SecureStorageService _storage = SecureStorageService();

  String? _conversationId;
  String? _currentUserId;
  List<dynamic> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _socketService.initSocket();
    _setupChat();
  }

  Future<void> _setupChat() async {
    final userData = await _storage.getUserData();
    _currentUserId = userData?['userId'];

    if (widget.bookData != null) {
      if (widget.bookData!['conversationId'] != null) {
        _conversationId = widget.bookData!['conversationId'];
      } else {
        // Try multiple ways to get sellerId
        final sellerId = widget.bookData!['sellerId'] ?? 
                         widget.bookData!['seller']?['id'] ?? 
                         widget.bookData!['seller']?['_id'];
        final bookId = widget.bookData!['id'];

        if (sellerId == null || bookId == null) {
          print('Chat Error: Missing sellerId ($sellerId) or bookId ($bookId)');
          setState(() => _isLoading = false);
          return;
        }

        final response = await _chatService.getOrCreateConversation(sellerId, bookId);
        if (response.success && response.data != null) {
          _conversationId = response.data!['id'];
        } else {
          print('Chat Error: Failed to get/create conversation: ${response.message}');
        }
      }

      if (_conversationId != null) {
        print('Joining chat conversation: $_conversationId');
        // Set active chat ID to prevent redundant notifications
        _socketService.activeConversationId = _conversationId;
        
        _socketService.joinChat(_conversationId!);
        
        // Mark messages as read
        _chatService.markAsRead(_conversationId!);
        
        final messagesResponse = await _chatService.getMessages(_conversationId!);
        if (messagesResponse.success) {
          setState(() {
            _messages = messagesResponse.data!;
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }

    _socketService.onMessageReceived(_onNewMessage);
  }

  void _onNewMessage(dynamic data) {
    if (mounted) {
      setState(() {
        if (!_messages.any((m) => m['id'] == data['id'])) {
          _messages.add(data);
          // Mark as read if we are in the chat
          _chatService.markAsRead(_conversationId!);
        }
      });
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _conversationId == null || _currentUserId == null) return;

    _socketService.sendMessage(
      _conversationId!,
      _currentUserId!,
      _messageController.text.trim(),
    );
    _messageController.clear();
  }

  @override
  void dispose() {
    // Clear active chat tracking
    _socketService.activeConversationId = null;
    _socketService.removeMessageListener(_onNewMessage);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String otherName = "Chat";
    if (widget.bookData?['conversationId'] != null) {
      otherName = widget.bookData?['otherUser']?['username'] ?? "User";
    } else {
      otherName = widget.bookData?['seller']?['username'] ?? "Seller";
    }

    final bookTitle = widget.bookData?['title'] ?? "Book";
    final bookPrice = widget.bookData?['sellingPrice'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF00BFA5).withValues(alpha: 0.2),
              child: Text(otherName[0].toUpperCase(), style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(otherName, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Online", style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              children: [
                const Icon(Icons.book, size: 20, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bookTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("₹$bookPrice", style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['senderId'] == _currentUserId;
                final timeStr = msg['createdAt'];
                final time = timeStr != null ? DateFormat('hh:mm a').format(DateTime.parse(timeStr).toLocal()) : "";

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF00BFA5) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: Radius.circular(isMe ? 15 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(msg['text'] ?? "", style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 15)),
                        const SizedBox(height: 3),
                        Text(time, style: TextStyle(color: isMe ? Colors.white70 : Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF00BFA5),
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
