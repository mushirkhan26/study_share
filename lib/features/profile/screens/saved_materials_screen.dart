import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/wishlist_provider.dart';
import '../../../widgets/book_card.dart';

class SavedMaterialsScreen extends StatelessWidget {
  const SavedMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!wishlistProvider.hasFetched && !wishlistProvider.isLoading) {
        wishlistProvider.fetchWishlist();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.savedBooks, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: wishlistProvider.isLoading && wishlistProvider.savedBooks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : wishlistProvider.savedBooks.isEmpty
              ? _buildEmptyState(context, l10n, theme)
              : RefreshIndicator(
                  onRefresh: () => wishlistProvider.fetchWishlist(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: wishlistProvider.savedBooks.length,
                    itemBuilder: (context, index) {
                      final book = wishlistProvider.savedBooks[index];
                      return GestureDetector(
                        onTap: () async {
                          await context.push(AppRoutes.bookDetailRoute, extra: book);
                          wishlistProvider.fetchWishlist();
                        },
                        child: BookCard(
                          title: book['title'],
                          author: book['author'],
                          sellingPrice: (book['sellingPrice'] as num).toInt(),
                          originalPrice: (book['originalPrice'] as num).toInt(),
                          condition: book['condition'],
                          tag: book['tag'] ?? "Book",
                          imageUrl: (book['images'] != null && (book['images'] as List).isNotEmpty) ? book['images'][0] : null,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: theme.dividerColor),
          const SizedBox(height: 15),
          Text(l10n.noSavedBooks, style: TextStyle(color: theme.hintColor, fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.homeRoute),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA5)),
            child: Text(l10n.exploreBooks, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
