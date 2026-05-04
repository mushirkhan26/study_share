import 'package:flutter/material.dart';

class MyUploadsScreen extends StatefulWidget {
  const MyUploadsScreen({super.key});

  @override
  State<MyUploadsScreen> createState() => _MyUploadsScreenState();
}

class _MyUploadsScreenState extends State<MyUploadsScreen> {
  // Dummy data
  final List<Map<String, dynamic>> _myAds = [
    {
      "title": "Let Us C - Yashavant Kanetkar",
      "price": 150,
      "date": "10 May 2026",
      "status": "Active"
    },
    {
      "title": "Data Structures in Java",
      "price": 250,
      "date": "08 May 2026",
      "status": "Sold"
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00BFA5);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("My Ads", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          // Mock refresh logic
        },
        color: primaryColor,
        child: _myAds.isEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 15),
                      const Text("You haven't posted any ads yet.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              )
            : ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: _myAds.length,
          itemBuilder: (context, index) {
          final ad = _myAds[index];
          final isActive = ad['status'] == 'Active';

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                // 🟢 Top Section: Book Details
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Placeholder
                      Container(
                        height: 80,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.book, color: Colors.grey),
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
                                    ad['title'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    ad['status'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isActive ? Colors.green : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text("₹${ad['price']}", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 5),
                            Text("Posted on: ${ad['date']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                // 🟢 Bottom Section: Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mark as Sold Button
                      if (isActive)
                        TextButton.icon(
                          onPressed: () {
                            setState(() => ad['status'] = 'Sold');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Ad marked as sold!"), backgroundColor: Colors.green),
                            );
                          },
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                          label: const Text("Mark Sold", style: TextStyle(color: Colors.green, fontSize: 13)),
                        ),

                      // Edit Button
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Edit feature coming soon!"), backgroundColor: Colors.blue),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 18),
                        label: const Text("Edit", style: TextStyle(color: Colors.blue, fontSize: 13)),
                      ),

                      // Delete Button
                      TextButton.icon(
                        onPressed: () => _confirmDelete(context, index),
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                        label: const Text("Delete", style: TextStyle(color: Colors.red, fontSize: 13)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    ),
    );
  }

  // Delete Confirmation Dialog
  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Ad?"),
        content: const Text("Are you sure you want to permanently delete this ad?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                setState(() {
                  _myAds.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ad deleted successfully"), backgroundColor: Colors.red),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}