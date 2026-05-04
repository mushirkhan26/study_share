import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      "category": "General",
      "questions": [
        {
          "q": "What is Study Share?",
          "a": "Study Share is a platform for students to buy, sell, and share second-hand study materials like books, notes, and guides."
        },
        {
          "q": "Is the app free to use?",
          "a": "Yes, browsing and posting ads on Study Share is completely free for all students."
        }
      ]
    },
    {
      "category": "Buying",
      "questions": [
        {
          "q": "How do I buy a book?",
          "a": "Find a book you like, click on it to see details, and use the 'Chat with Seller' button to negotiate and arrange the purchase."
        },
        {
          "q": "Can I pay through the app?",
          "a": "Currently, we only facilitate the connection between buyers and sellers. Payments should be handled directly between both parties."
        }
      ]
    },
    {
      "category": "Selling",
      "questions": [
        {
          "q": "How do I post an ad?",
          "a": "Go to the 'Sell' tab, upload a photo of your book, fill in the details and price, and click 'Post Ad'."
        },
        {
          "q": "How many ads can I post?",
          "a": "You can post as many ads as you want, as long as they follow our community guidelines."
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Help Center", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Search Bar Section ---
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary.withValues(alpha: 0.05),
              child: Column(
                children: [
                  const Text(
                    "How can we help you?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search help articles...",
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- FAQ Sections ---
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _faqs.map((category) => _buildFaqCategory(category)).toList(),
              ),
            ),

            // --- Contact Support Section ---
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            _buildContactCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqCategory(Map<String, dynamic> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Text(
            category['category'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        ... (category['questions'] as List).map((qna) => ExpansionTile(
          title: Text(qna['q'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                qna['a'],
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.4),
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Text("Still have questions?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          const Text(
            "If you can't find an answer in our FAQ, you can reach out to our support team.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.email_outlined, color: Colors.white),
            label: const Text("Contact Support", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
