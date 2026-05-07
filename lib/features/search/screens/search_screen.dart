import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/book_card.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/api/network/book_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final BookService _bookService = BookService();
  
  // Filters state
  String _selectedCourse = 'All';
  String _searchQuery = '';
  
  List<dynamic> _books = [];
  bool _isLoading = true;
  Timer? _debounce;

  final List<String> _courses = ['All', 'BCA', 'B.Tech', 'B.Sc', 'BA', 'B.Com', 'Novels', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    setState(() => _isLoading = true);
    final response = await _bookService.getAllBooks(
      search: _searchQuery,
      tag: _selectedCourse,
    );
    if (response.success && response.data != null) {
      setState(() {
        _books = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
      _fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Search Books", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          if (_selectedCourse != 'All' || _searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined, color: Color(0xFF00BFA5)),
              onPressed: () {
                setState(() {
                  _selectedCourse = 'All';
                  _searchQuery = '';
                });
                _fetchBooks();
              },
            )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔎 Search Bar
            TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search by title or author...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00BFA5)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🎛️ Course Filters
            const Text("Course / Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _courses.map((course) => _buildFilterChip(
                  label: course,
                  isSelected: _selectedCourse == course,
                  onTap: () {
                    setState(() => _selectedCourse = course);
                    _fetchBooks();
                  },
                )).toList(),
              ),
            ),

            const SizedBox(height: 25),
            Text(
              _isLoading ? "Searching..." : "Results (${_books.length} found)", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)
            ),
            const SizedBox(height: 15),

            // 📊 Search Results Grid
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _books.isEmpty 
                  ? _buildEmptyResults()
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        return GestureDetector(
                          onTap: () => context.push(AppRoutes.bookDetailRoute, extra: book),
                          child: BookCard(
                            title: book['title'],
                            author: book['author'],
                            sellingPrice: book['sellingPrice'].toInt(),
                            originalPrice: book['originalPrice'].toInt(),
                            condition: book['condition'],
                            tag: book['tag'] ?? "Book",
                            imageUrl: (book['images'] as List).isNotEmpty ? book['images'][0] : null,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text("No books found matching your search.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  // Filter Chip Widget
  Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00BFA5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF00BFA5) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
