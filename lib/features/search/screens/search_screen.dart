import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/book_card.dart';
import '../../../config/navigation/app_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Filters state
  String _selectedCourse = 'All';
  String _selectedSemester = 'All';
  String _searchQuery = '';

  final List<String> _courses = ['All', 'BCA', 'B.Tech', 'B.Sc', 'BA', 'B.Com'];
  final List<String> _semesters = ['All', '1st Sem', '2nd Sem', '3rd Sem', '4th Sem', '5th Sem', '6th Sem'];

  // Dummy Data for Search
  final List<Map<String, dynamic>> _allBooks = [
    {"title": "Let Us C", "author": "Yashavant Kanetkar", "sell": 150, "orig": 350, "cond": "Good", "course": "BCA", "sem": "1st Sem"},
    {"title": "Data Structures in Java", "author": "Robert Lafore", "sell": 250, "orig": 600, "cond": "Like New", "course": "BCA", "sem": "3rd Sem"},
    {"title": "Engineering Mathematics", "author": "H.K. Dass", "sell": 300, "orig": 750, "cond": "Old", "course": "B.Tech", "sem": "1st Sem"},
    {"title": "Java: The Complete Reference", "author": "Herbert Schildt", "sell": 450, "orig": 900, "cond": "Like New", "course": "BCA", "sem": "4th Sem"},
    {"title": "Python Programming", "author": "Reema Thareja", "sell": 200, "orig": 500, "cond": "Good", "course": "B.Sc", "sem": "2nd Sem"},
    {"title": "Software Engineering", "author": "Sommerville", "sell": 350, "orig": 850, "cond": "Good", "course": "B.Tech", "sem": "4th Sem"},
  ];

  List<Map<String, dynamic>> get _filteredBooks {
    return _allBooks.where((book) {
      final matchesCourse = _selectedCourse == 'All' || book['course'] == _selectedCourse;
      final matchesSem = _selectedSemester == 'All' || book['sem'] == _selectedSemester;
      final matchesSearch = _searchQuery.isEmpty || 
          book['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['author'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesCourse && matchesSem && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = _filteredBooks;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Search Books", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          if (_selectedCourse != 'All' || _selectedSemester != 'All' || _searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined, color: Color(0xFF00BFA5)),
              onPressed: () {
                setState(() {
                  _selectedCourse = 'All';
                  _selectedSemester = 'All';
                  _searchQuery = '';
                });
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
              onChanged: (value) => setState(() => _searchQuery = value),
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
            const Text("Course", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _courses.map((course) => _buildFilterChip(
                  label: course,
                  isSelected: _selectedCourse == course,
                  onTap: () => setState(() => _selectedCourse = course),
                )).toList(),
              ),
            ),
            const SizedBox(height: 15),

            // 📚 Semester Filters
            const Text("Semester", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _semesters.map((sem) => _buildFilterChip(
                  label: sem,
                  isSelected: _selectedSemester == sem,
                  onTap: () => setState(() => _selectedSemester = sem),
                )).toList(),
              ),
            ),

            const SizedBox(height: 25),
            Text(
              "Results (${filteredResults.length} found)", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)
            ),
            const SizedBox(height: 15),

            // 📊 Search Results Grid
            Expanded(
              child: filteredResults.isEmpty 
                ? _buildEmptyResults()
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final book = filteredResults[index];
                      return GestureDetector(
                        onTap: () => context.push(AppRoutes.bookDetailRoute),
                        child: BookCard(
                          title: book['title'],
                          author: book['author'],
                          sellingPrice: book['sell'],
                          originalPrice: book['orig'],
                          condition: book['cond'],
                          tag: "${book['course']} ${book['sem']}",
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
          const Text("No books found matching your filters.", style: TextStyle(color: Colors.grey, fontSize: 16)),
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