import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/api/network/chat_service.dart';
import '../../../core/services/secure_storage_service.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final ChatService _chatService = ChatService();
  final SecureStorageService _storage = SecureStorageService();
  
  List<dynamic> _conversations = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final userData = await _storage.getUserData();
    _currentUserId = userData?['userId'];

    final response = await _chatService.getConversations();
    if (response.success && response.data != null) {
      setState(() {
        _conversations = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Chats", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? _buildEmptyInbox()
              : RefreshIndicator(
                  onRefresh: _loadConversations,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(15),
                    itemCount: _conversations.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final conv = _conversations[index];
                      final book = conv['book'];
                      
                      final isBuyer = conv['buyerId'] == _currentUserId;
                      final otherUser = isBuyer ? conv['seller'] : conv['buyer'];
                      
                      final String bookTitle = book?['title'] ?? "Deleted Book";
                      final imageUrl = (book != null && book['images'] != null && book['images'].isNotEmpty) 
                          ? book['images'][0] 
                          : null;

                      return ListTile(
                        onTap: () {
                          if (book == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("This book is no longer available.")),
                            );
                            return;
                          }
                          // Prepare book data with conversationId
                          final bookData = {
                            'id': book['id'],
                            'title': book['title'],
                            'sellingPrice': book['sellingPrice'],
                            'conversationId': conv['id'], // Crucial!
                            'otherUser': otherUser,
                            'sellerId': conv['sellerId'],
                          };
                          context.push(AppRoutes.chatRoute, extra: bookData);
                        },
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                          child: imageUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
                        ),
                        title: Text(
                          otherUser?['username'] ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          "Regarding: $bookTitle",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyInbox() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text("No active conversations found.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
