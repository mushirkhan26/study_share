import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/wishlist_provider.dart';
import '../../../widgets/book_card.dart';

class SavedMaterialsScreen extends StatelessWidget {
  const SavedMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!wishlistProvider.hasFetched && !wishlistProvider.isLoading) {
        wishlistProvider.fetchWishlist();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Saved Books", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: wishlistProvider.isLoading && wishlistProvider.savedBooks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : wishlistProvider.savedBooks.isEmpty
              ? _buildEmptyState(context)
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text("No saved books yet.", style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.homeRoute),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA5)),
            child: const Text("Explore Books", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
