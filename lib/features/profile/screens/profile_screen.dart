import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00BFA5); // Teal theme color

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("My Account", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
        automaticallyImplyLeading: false, // Bottom bar screen
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- 👤 User Header ---
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, size: 50, color: primaryColor),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text("Habib Khan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("BCA Student • Jodhpur", style: TextStyle(color: Colors.grey, fontSize: 14)),

            const SizedBox(height: 25),

            // --- 📊 Seller Stats ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem("Active Ads", "3", primaryColor),
                    Container(height: 40, width: 1, color: Colors.grey.shade300),
                    _buildStatItem("Books Sold", "5", Colors.black),
                    Container(height: 40, width: 1, color: Colors.grey.shade300),
                    _buildStatItem("Earnings", "₹850", Colors.green),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),

            // --- ⚙️ Menu Options ---
            _buildProfileTile(
              icon: Icons.inventory_2_outlined,
              title: "My Ads (Manage Books)",
              subtitle: "Edit, delete, or mark as sold",
              onTap: () => context.push(AppRoutes.myUploads),
            ),
            _buildProfileTile(
              icon: Icons.favorite_border,
              title: "Wishlist",
              subtitle: "Books you have saved",
              onTap: () => context.push(AppRoutes.savedMaterials),
            ),
            _buildProfileTile(
              icon: Icons.chat_bubble_outline,
              title: "My Chats",
              subtitle: "Conversations with buyers/sellers",
              onTap: () {}, // Optional: Alag chat list screen ke liye
            ),
            _buildProfileTile(
              icon: Icons.settings_outlined,
              title: "Settings",
              subtitle: "Notifications, privacy, and more",
              onTap: () => context.push(AppRoutes.settings),
            ),

            const SizedBox(height: 80), // Bottom nav bar clearance
          ],
        ),
      ),
    );
  }

  // Stats Helper Widget
  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // List Tile Helper Widget
  Widget _buildProfileTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF00BFA5).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF00BFA5)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Logout Dialog
  // void _showLogoutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       title: const Text("Logout"),
  //       content: const Text("Are you sure you want to securely logout from BookHub?"),
  //       actions: [
  //         TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             context.go(AppRoutes.loginRoute);
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  //           child: const Text("Logout", style: TextStyle(color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}