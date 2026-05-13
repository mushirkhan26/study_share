import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/book_provider.dart';
import '../../../core/utils/ui_utils.dart';

class MyUploadsScreen extends StatelessWidget {
  const MyUploadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bookProvider = Provider.of<BookProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!bookProvider.hasFetchedMyBooks && !bookProvider.isLoading) {
        bookProvider.fetchMyBooks();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.myUploads, style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: bookProvider.isLoading && bookProvider.myBooks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : bookProvider.myBooks.isEmpty
              ? _buildEmptyState(l10n, theme)
              : RefreshIndicator(
                  onRefresh: () => bookProvider.fetchMyBooks(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: bookProvider.myBooks.length,
                    itemBuilder: (context, index) {
                      final book = bookProvider.myBooks[index];
                      final bool isSold = book['isSold'] ?? false;
                      final imageUrl = (book['images'] != null && (book['images'] as List).isNotEmpty) 
                          ? book['images'][0] 
                          : null;
                      final String bookId = book['id'] ?? book['_id'];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                        color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 80,
                                  height: 110,
                                  color: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
                                  child: imageUrl != null 
                                    ? Image.network(imageUrl, fit: BoxFit.cover)
                                    : Icon(Icons.book, color: theme.hintColor),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            book['title'],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isSold)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(5)),
                                            child: const Text("SOLD", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10)),
                                          ),
                                      ],
                                    ),
                                    Text("₹${book['sellingPrice']}", style: const TextStyle(color: Color(0xFF00BFA5), fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _buildActionButton(
                                          isSold ? Icons.undo : Icons.check_circle_outline,
                                          isSold ? l10n.available : l10n.markSold,
                                          isSold ? Colors.orange : Colors.green,
                                          () => _toggleSoldStatus(context, bookId, isSold, l10n),
                                        ),
                                        _buildActionButton(
                                          Icons.delete_outline,
                                          l10n.delete,
                                          Colors.red,
                                          () => _deleteAd(context, bookId, l10n),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _toggleSoldStatus(BuildContext context, String id, bool currentStatus, AppLocalizations l10n) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final success = await bookProvider.updateBookStatus(id, !currentStatus);
    if (success && context.mounted) {
       UIUtils.showSnackBar(context, l10n.statusUpdated);
    }
  }

  void _deleteAd(BuildContext context, String id, AppLocalizations l10n) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAdConfirmTitle),
        content: Text(l10n.deleteAdConfirmContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.delete, style: const TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      final success = await bookProvider.deleteBook(id);
      if (success && context.mounted) {
        UIUtils.showSnackBar(context, l10n.adDeletedSuccess);
      }
    }
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 80, color: theme.dividerColor),
          const SizedBox(height: 15),
          Text(l10n.noAdsPosted, style: TextStyle(color: theme.hintColor, fontSize: 16)),
        ],
      ),
    );
  }
}
