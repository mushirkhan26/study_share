import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/book_card.dart';
import '../../../config/navigation/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data for Books
    final List<Map<String, dynamic>> dummyBooks = [
      {"title": "Let Us C", "author": "Yashavant Kanetkar", "sell": 150, "orig": 350, "cond": "Good", "tag": "BCA 1st Yr"},
      {"title": "Data Structures in Java", "author": "Robert Lafore", "sell": 250, "orig": 600, "cond": "Like New", "tag": "Programming"},
      {"title": "Software Engineering", "author": "Ian Sommerville", "sell": 300, "orig": 800, "cond": "Old", "tag": "BCA Final Yr"},
      {"title": "Head First Java", "author": "Kathy Sierra", "sell": 400, "orig": 950, "cond": "Like New", "tag": "Java"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Discover Books", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
            Text("Find second-hand books from seniors", style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
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
              TextField(
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
              const SizedBox(height: 25),

              // Categories (Horizontal Scroll)
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip("All Books", true),
                    _buildCategoryChip("BCA Semesters", false),
                    _buildCategoryChip("Programming", false),
                    _buildCategoryChip("Novels", false),
                  ],
                ),
              ),
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
                physics: const NeverScrollableScrollPhysics(), // Scroll single child scroll view sambhalega
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Ek row mein 2 books
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.65, // Card ki height aur width ka ratio
                ),
                itemCount: dummyBooks.length,
                itemBuilder: (context, index) {
                  final book = dummyBooks[index];
                  return GestureDetector(
                    onTap: (){
                      context.push(AppRoutes.bookDetailRoute);
                    },
                    child: BookCard(
                      title: book["title"],
                      author: book["author"],
                      sellingPrice: book["sell"],
                      originalPrice: book["orig"],
                      condition: book["cond"],
                      tag: book["tag"],
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

  // Category Chip Builder
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? const Color(0xFF00BFA5) : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}