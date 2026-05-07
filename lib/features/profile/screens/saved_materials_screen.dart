import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/api/network/wishlist_service.dart';
import '../../../widgets/book_card.dart';

class SavedMaterialsScreen extends StatefulWidget {
  const SavedMaterialsScreen({super.key});

  @override
  State<SavedMaterialsScreen> createState() => _SavedMaterialsScreenState();
}

class _SavedMaterialsScreenState extends State<SavedMaterialsScreen> {
  final WishlistService _wishlistService = WishlistService();
  List<dynamic> _savedBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedBooks();
  }

  Future<void> _fetchSavedBooks() async {
    setState(() => _isLoading = true);
    final response = await _wishlistService.getWishlist();
    if (response.success && response.data != null) {
      setState(() {
        _savedBooks = response.data!;
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
        title: const Text("Saved Books", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedBooks.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _fetchSavedBooks,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: _savedBooks.length,
                    itemBuilder: (context, index) {
                      final book = _savedBooks[index];
                      return GestureDetector(
                        onTap: () async {
                          await context.push(AppRoutes.bookDetailRoute, extra: book);
                          _fetchSavedBooks(); // Refresh if they removed from wishlist in detail screen
                        },
                        child: BookCard(
                          title: book['title'],
                          author: book['author'],
                          sellingPrice: (book['sellingPrice'] as num).toInt(),
                          originalPrice: (book['originalPrice'] as num).toInt(),
                          condition: book['condition'],
                          tag: book['tag'] ?? "Book",
                          imageUrl: (book['images'] as List).isNotEmpty ? book['images'][0] : null,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
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
