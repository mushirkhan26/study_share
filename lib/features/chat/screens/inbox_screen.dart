import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/chat_provider.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Fetch conversations on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatProvider.conversations.isEmpty && !chatProvider.isLoading) {
        chatProvider.fetchConversations();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.myChats, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: chatProvider.isLoading && chatProvider.conversations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : chatProvider.conversations.isEmpty
              ? _buildEmptyInbox(theme, l10n)
              : RefreshIndicator(
                  onRefresh: () => chatProvider.fetchConversations(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(15),
                    itemCount: chatProvider.conversations.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
                    itemBuilder: (context, index) {
                      final conv = chatProvider.conversations[index];
                      final book = conv['book'];
                      
                      final isBuyer = conv['buyerId'] == authProvider.user?.id;
                      final otherUser = isBuyer ? conv['seller'] : conv['buyer'];
                      
                      final String bookTitle = book?['title'] ?? l10n.bookNotAvailable;
                      final imageUrl = (book != null && book['images'] != null && book['images'].isNotEmpty) 
                          ? book['images'][0] 
                          : null;

                      return ListTile(
                        onTap: () {
                          if (book == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.bookNotAvailable)),
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
                          backgroundColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                          backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
                          child: imageUrl == null ? Icon(Icons.person, color: theme.hintColor) : null,
                        ),
                        title: Text(
                          otherUser?['username'] ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          l10n.regarding(bookTitle),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: theme.hintColor, fontSize: 13),
                        ),
                        trailing: Icon(Icons.chevron_right, size: 20, color: theme.hintColor),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyInbox(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: theme.dividerColor),
          const SizedBox(height: 15),
          Text(l10n.noConversations, style: TextStyle(color: theme.hintColor, fontSize: 16)),
        ],
      ),
    );
  }
}
