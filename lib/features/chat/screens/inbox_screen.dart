import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/chat_provider.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Fetch conversations on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatProvider.conversations.isEmpty && !chatProvider.isLoading) {
        chatProvider.fetchConversations();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Chats", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: chatProvider.isLoading && chatProvider.conversations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : chatProvider.conversations.isEmpty
              ? _buildEmptyInbox()
              : RefreshIndicator(
                  onRefresh: () => chatProvider.fetchConversations(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(15),
                    itemCount: chatProvider.conversations.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final conv = chatProvider.conversations[index];
                      final book = conv['book'];
                      
                      final isBuyer = conv['buyerId'] == authProvider.user?.id;
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
                          final bookData = {
                            'id': book['id'] ?? book['_id'],
                            'title': book['title'],
                            'sellingPrice': book['sellingPrice'],
                            'conversationId': conv['id'] ?? conv['_id'],
                            'otherUser': otherUser,
                            'sellerId': conv['sellerId'],
                          };
                          context.push(AppRoutes.chatRoute, extra: bookData);
                        },
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
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
