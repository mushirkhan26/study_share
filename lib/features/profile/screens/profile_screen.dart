import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final stats = authProvider.stats;
    const Color primaryColor = Color(0xFF00BFA5);

    // Initial fetch if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null && authProvider.stats == null && user.isSeller) {
         authProvider.fetchProfile();
      }
    });

    if (authProvider.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isSeller = user?.isSeller ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("My Account", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () async {
              await context.push(AppRoutes.editProfile);
              authProvider.fetchProfile();
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => authProvider.fetchProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
        
              // --- 👤 User Header ---
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  backgroundImage: user?.profileImage != null ? CachedNetworkImageProvider(user!.profileImage!) : null,
                  child: user?.profileImage == null 
                      ? const Icon(Icons.person, size: 50, color: primaryColor)
                      : null,
                ),
              ),
              const SizedBox(height: 15),
              Text(user?.username ?? "User", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("${user?.college ?? 'Student'} • Jodhpur", style: const TextStyle(color: Colors.grey, fontSize: 14)),
        
              const SizedBox(height: 25),
        
              // --- 📊 Seller Stats ---
              if (isSeller)
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
                        _buildStatItem("Active Ads", "${stats?['activeAds'] ?? 0}", primaryColor),
                        Container(height: 40, width: 1, color: Colors.grey.shade300),
                        _buildStatItem("Books Sold", "${stats?['booksSold'] ?? 0}", Colors.black),
                        Container(height: 40, width: 1, color: Colors.grey.shade300),
                        _buildStatItem("Earnings", "₹${stats?['earnings'] ?? 0}", Colors.green),
                      ],
                    ),
                  ),
                ),
        
              const SizedBox(height: 30),
              const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
        
              // --- ⚙️ Menu Options ---
              if (isSeller)
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
                onTap: () => context.push(AppRoutes.inboxRoute),
              ),
              _buildProfileTile(
                icon: Icons.settings_outlined,
                title: "Settings",
                subtitle: "Notifications, privacy, and more",
                onTap: () => context.push(AppRoutes.settings),
              ),
        
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
      ],
    );
  }

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
}
