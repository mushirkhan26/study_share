import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/chat_provider.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupChat();
    });
  }

  void _setupChat() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    String? conversationId;
    String? sellerId;
    String? bookId;

    if (widget.bookData != null) {
      conversationId = widget.bookData!['conversationId'];
      sellerId = widget.bookData!['sellerId'] ?? 
                 widget.bookData!['seller']?['id'] ?? 
                 widget.bookData!['seller']?['_id'];
      bookId = widget.bookData!['id'] ?? widget.bookData!['_id'];

      chatProvider.initializeChat(
        conversationId: conversationId,
        sellerId: sellerId,
        bookId: bookId,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final conversationId = chatProvider.activeConversationId;
    final currentUserId = authProvider.user?.id;
    
    if (conversationId != null && currentUserId != null) {
      chatProvider.sendMessage(conversationId, _messageController.text.trim(), currentUserId, "");
      _messageController.clear();
    } else {
      // Handle case where conversation ID is not yet ready
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Initializing chat, please wait...")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    String otherName = "Chat";
    if (widget.bookData?['conversationId'] != null) {
      otherName = widget.bookData?['otherUser']?['username'] ?? "User";
    } else {
      otherName = widget.bookData?['seller']?['username'] ?? "Seller";
    }

    final bookTitle = widget.bookData?['title'] ?? "Book";
    final bookPrice = widget.bookData?['sellingPrice'] ?? 0;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
           Provider.of<ChatProvider>(context, listen: false).clearActiveConversation();
        }
      },
      child: Scaffold(
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
        body: Column(
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
              child: chatProvider.isLoading && chatProvider.messages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatProvider.messages[index];
                  final isMe = msg['senderId'] == authProvider.user?.id;
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
                        icon: chatProvider.isLoading && chatProvider.activeConversationId == null
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
