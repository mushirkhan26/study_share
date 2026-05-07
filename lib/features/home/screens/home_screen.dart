import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/book_card.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/models/user_model.dart';
import '../../../core/api/network/book_service.dart';
import '../../../core/services/secure_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService _bookService = BookService();
  final SecureStorageService _storage = SecureStorageService();
  
  UserModel? _currentUser;
  List<dynamic> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userData = await _storage.getUserData();
    if (userData != null) {
      _currentUser = UserModel(
        id: userData['userId'] ?? '',
        username: userData['username'] ?? 'User',
        email: userData['email'] ?? '',
        role: UserRoleExtension.fromString(userData['role'] ?? 'buyer'),
      );
    }
    
    final response = await _bookService.getAllBooks();
    if (response.success && response.data != null) {
      setState(() {
        _books = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (_currentUser?.isSeller ?? false) 
                  ? "Hello Seller, ${_currentUser?.username}" 
                  : "Discover Books, ${_currentUser?.username}", 
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)
            ),
            const Text("Find second-hand books from seniors", style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              GestureDetector(
                onTap: () => context.push(AppRoutes.searchRoute),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for books, authors, or subjects...",
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF00BFA5)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Categories (Horizontal Scroll)
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),

              // 📚 Study Materials Banner
              _buildMaterialsBanner(context),
              const SizedBox(height: 30),

              //  Recently Added Books (Grid Layout)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recently Added", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All", style: TextStyle(color: Color(0xFF00BFA5))),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                    onTap: () {
                      context.push(AppRoutes.bookDetailRoute, extra: book);
                    },
                    child: BookCard(
                      title: book["title"],
                      author: book["author"],
                      sellingPrice: book["sellingPrice"].toInt(),
                      originalPrice: book["originalPrice"].toInt(),
                      condition: book["condition"],
                      tag: book["tag"] ?? "Book",
                      imageUrl: (book["images"] as List).isNotEmpty ? book["images"][0] : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 80), // Bottom bar ke liye extra space
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMaterialsBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00BFA5).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF00BFA5).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Need Study Notes?",
                  style: TextStyle(color: Color(0xFF009688), fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Get PDFs and handwritten notes from toppers.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.studyMaterialsRoute),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BFA5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Browse", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBecomeSellerBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BFA5), Color(0xFF009688)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Have old books?",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Sell them to your juniors and earn!",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic to switch role or go to sell screen
              context.push(AppRoutes.sellRoute);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF00BFA5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Start Selling", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}