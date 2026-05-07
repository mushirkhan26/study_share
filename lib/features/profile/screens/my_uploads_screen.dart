import 'package:flutter/material.dart';
import '../../../core/api/network/book_service.dart';
import '../../../core/utils/ui_utils.dart';

class MyUploadsScreen extends StatefulWidget {
  const MyUploadsScreen({super.key});

  @override
  State<MyUploadsScreen> createState() => _MyUploadsScreenState();
}

class _MyUploadsScreenState extends State<MyUploadsScreen> {
  final BookService _bookService = BookService();
  List<dynamic> _myBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMyAds();
  }

  Future<void> _fetchMyAds() async {
    setState(() => _isLoading = true);
    final response = await _bookService.getMyAds();
    if (response.success && response.data != null) {
      setState(() {
        _myBooks = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _toggleSoldStatus(String id, bool currentStatus) async {
    final response = await _bookService.updateBookStatus(id, !currentStatus);
    if (response.success) {
      _fetchMyAds();
      if (mounted) UIUtils.showSnackBar(context, "Status updated!");
    }
  }

  void _deleteAd(String id) async {
    // Confirm delete
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Ad?"),
        content: const Text("Are you sure you want to remove this book listing?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      final response = await _bookService.deleteBook(id);
      if (response.success) {
        _fetchMyAds();
        if (mounted) UIUtils.showSnackBar(context, "Ad deleted successfully");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Ads", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myBooks.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _fetchMyAds,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _myBooks.length,
                    itemBuilder: (context, index) {
                      final book = _myBooks[index];
                      final bool isSold = book['isSold'] ?? false;
                      final imageUrl = (book['images'] != null && (book['images'] as List).isNotEmpty) 
                          ? book['images'][0] 
                          : null;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                        color: Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Book Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 80,
                                  height: 110,
                                  color: Colors.grey[200],
                                  child: imageUrl != null 
                                    ? Image.network(imageUrl, fit: BoxFit.cover)
                                    : const Icon(Icons.book, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 15),
                              // Details
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
                                    // Action Buttons (Using Wrap to prevent overflow)
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _buildActionButton(
                                          isSold ? Icons.undo : Icons.check_circle_outline,
                                          isSold ? "Available" : "Mark Sold",
                                          isSold ? Colors.orange : Colors.green,
                                          () => _toggleSoldStatus(book['id'], isSold),
                                        ),
                                        _buildActionButton(
                                          Icons.delete_outline,
                                          "Delete",
                                          Colors.red,
                                          () => _deleteAd(book['id']),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text("You haven't posted any ads yet.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
