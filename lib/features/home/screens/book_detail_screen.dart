import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/api/network/wishlist_service.dart';
import '../../../core/utils/ui_utils.dart';


class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? bookData;

  const BookDetailScreen({
    super.key,
    this.bookData,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final WishlistService _wishlistService = WishlistService();
  bool _isSaved = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
  }

  Future<void> _checkSavedStatus() async {
    if (widget.bookData != null && widget.bookData!['id'] != null) {
      final response = await _wishlistService.checkIfSaved(widget.bookData!['id']);
      if (response.success && mounted) {
        setState(() {
          _isSaved = response.data ?? false;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleSave() async {
    if (widget.bookData == null || widget.bookData!['id'] == null) return;

    final response = await _wishlistService.toggleWishlist(widget.bookData!['id']);
    if (response.success && mounted) {
      setState(() {
        _isSaved = response.data!['saved'];
      });
      UIUtils.showSnackBar(context, response.data!['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract data from bookData or use defaults
    final String title = widget.bookData?['title'] ?? "Book Title";
    final String author = widget.bookData?['author'] ?? "Unknown Author";
    final int sellingPrice = (widget.bookData?['sellingPrice'] ?? 0).toInt();
    final int originalPrice = (widget.bookData?['originalPrice'] ?? 0).toInt();
    final String condition = widget.bookData?['condition'] ?? "Good";
    final String description = widget.bookData?['description'] ?? "No description provided.";
    final String sellerName = widget.bookData?['seller']?['username'] ?? "Anonymous";
    
    final List<dynamic>? images = widget.bookData?['images'];
    final String? imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

    return Scaffold(
      backgroundColor: Colors.white,
      // 🟢 Custom App Bar over Image
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
                  _isSaved ? Icons.favorite : Icons.favorite_border, 
                  color: _isSaved ? Colors.red : Colors.black, 
                  size: 20
                ),
                onPressed: _toggleSave,
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

      // 🟢 Main Content
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Book Image Section
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
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
                  // 🏷️ Price & Condition Badges
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

                  // 📝 Title & Author
                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 5),
                  Text("By $author", style: const TextStyle(fontSize: 16, color: Colors.grey)),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),

                  // 📄 Description
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),

                  // 👤 Seller Info Box
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
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),

      // 🟢 Sticky Bottom Action Bar
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
              // Chat Button (Primary Action)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(AppRoutes.chatRoute, extra: widget.bookData);
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