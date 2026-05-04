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
  String _selectedCourse = 'BCA';
  String _selectedSemester = 'All';

  final List<String> _courses = ['All', 'BCA', 'B.Tech', 'B.Sc', 'BA', 'B.Com'];
  final List<String> _semesters = ['All', '1st Sem', '2nd Sem', '3rd Sem', '4th Sem', '5th Sem', '6th Sem'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Search Books", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false, // Bottom bar wali screen hai isliye back button hide karenge
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔎 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search by title, author, or keyword...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00BFA5)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic_none, color: Colors.grey),
                  onPressed: () {}, // Voice search dummy
                ),
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
            const Text("Results (4 found)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 15),

            // 📊 Search Results Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.65,
                ),
                itemCount: 4, // Dummy count
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => context.push(AppRoutes.bookDetailRoute),
                    child: const BookCard(
                      title: "Let Us C",
                      author: "Yashavant Kanetkar",
                      sellingPrice: 150,
                      originalPrice: 350,
                      condition: "Good",
                      tag: "BCA 1st Sem",
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 60), // Bottom bar clearance
          ],
        ),
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