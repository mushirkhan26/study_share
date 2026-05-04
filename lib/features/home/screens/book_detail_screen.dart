import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';

class BookDetailScreen extends StatelessWidget {
  // Real app mein ye data API ya pichli screen se aayega
  final String title;
  final String author;
  final int sellingPrice;
  final int originalPrice;
  final String condition;
  final String description;
  final String sellerName;

  const BookDetailScreen({
    super.key,
    this.title = "Data Structures in Java",
    this.author = "Robert Lafore",
    this.sellingPrice = 250,
    this.originalPrice = 600,
    this.condition = "Like New",
    this.description = "Selling my BCA 3rd semester DSA book. It is in excellent condition, no torn pages or pen marks. Used it very carefully.",
    this.sellerName = "Rahul M.",
  });

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(Icons.favorite_border, color: Colors.black, size: 20),
                onPressed: () {},
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
              child: const Center(
                child: Icon(Icons.menu_book, size: 100, color: Colors.grey),
                // Real app mein yahan Image.network aayega:
                // Image.network(imageUrl, fit: BoxFit.cover),
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
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
                        ),
                        child: Text(condition, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
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
                              const Text("BCA Student • Jodhpur", style: TextStyle(color: Colors.grey, fontSize: 13)), // Aapke app ke context ke hisaab se
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
                    context.push(AppRoutes.chatRoute);
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
}