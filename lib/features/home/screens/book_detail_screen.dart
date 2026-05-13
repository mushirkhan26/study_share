import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/wishlist_provider.dart';
import '../../../core/utils/url_utils.dart';

class BookDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? bookData;

  const BookDetailScreen({
    super.key,
    this.bookData,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final String bookId = bookData?['id'] ?? bookData?['_id'] ?? '';
    final bool isSaved = wishlistProvider.isBookSaved(bookId);

    // Check status on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bookId.isNotEmpty && !wishlistProvider.isBookSaved(bookId)) {
        wishlistProvider.checkIfSaved(bookId);
      }
    });

    final String title = bookData?['title'] ?? "Book Title";
    final String author = bookData?['author'] ?? "Unknown Author";
    final int sellingPrice = (bookData?['sellingPrice'] ?? 0).toInt();
    final int originalPrice = (bookData?['originalPrice'] ?? 0).toInt();
    final String condition = bookData?['condition'] ?? "Good";
    final String description = bookData?['description'] ?? "No description provided.";
    final String sellerName = bookData?['seller']?['username'] ?? "Anonymous";
    
    final List<dynamic>? images = bookData?['images'];
    final String? imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border, 
                  color: isSaved ? Colors.red : Colors.black, 
                  size: 20
                ),
                onPressed: () => wishlistProvider.toggleWishlist(bookId),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.black, size: 20),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: UrlUtils.normalizeImageUrl(imageUrl) != null
                  ? CachedNetworkImage(
                      imageUrl: UrlUtils.normalizeImageUrl(imageUrl)!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.menu_book, size: 100, color: Colors.grey),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.menu_book, size: 100, color: Colors.grey),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("₹$sellingPrice", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5))),
                          const SizedBox(width: 10),
                          Text("₹$originalPrice", style: const TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getConditionColor(condition).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getConditionColor(condition).withValues(alpha: 0.5)),
                        ),
                        child: Text(condition, style: TextStyle(color: _getConditionColor(condition), fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 5),
                  Text("By $author", style: const TextStyle(fontSize: 16, color: Colors.grey)),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),

                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),

                  const Text("Seller Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFF00BFA5).withValues(alpha: 0.2),
                          child: const Icon(Icons.person, color: Color(0xFF00BFA5)),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sellerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const Text("Student Seller", style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(AppRoutes.chatRoute, extra: bookData);
                  },
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  label: const Text("Chat with Seller", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color(0xFF00BFA5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getConditionColor(String condition) {
    if (condition == "Like New") return Colors.green;
    if (condition == "Good") return Colors.orange;
    if (condition == "Old") return Colors.red;
    return Colors.grey;
  }
}
