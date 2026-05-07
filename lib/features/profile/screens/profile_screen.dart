import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/models/user_model.dart';
import '../../../core/api/network/auth_service.dart';
import '../../../core/services/secure_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final SecureStorageService _storage = SecureStorageService();
  
  UserModel? _user;
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // First load from storage for instant UI
    final localData = await _storage.getUserData();
    if (localData != null) {
      setState(() {
        _user = UserModel(
          id: localData['userId'],
          username: localData['username'],
          email: localData['email'],
          role: UserRoleExtension.fromString(localData['role']),
          profileImage: localData['profileImage'],
          college: localData['college'],
        );
        _isLoading = false;
      });
    }

    // Then fetch fresh data from API
    final response = await _authService.getUserProfile();
    if (response.success && response.data != null) {
      setState(() {
        _user = response.data;
      });
      
      // Load stats if seller
      if (_user!.isSeller) {
        final statsResponse = await _authService.getUserStats();
        if (statsResponse.success) {
          setState(() {
            _stats = statsResponse.data;
          });
        }
      }
      
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00BFA5);

    if (_isLoading && _user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isSeller = _user?.isSeller ?? false;

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
              _loadProfile(); // Reload after editing
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
        
              // --- 👤 User Header ---
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  backgroundImage: _user?.profileImage != null ? NetworkImage(_user!.profileImage!) : null,
                  child: _user?.profileImage == null 
                      ? const Icon(Icons.person, size: 50, color: primaryColor)
                      : null,
                ),
              ),
              const SizedBox(height: 15),
              Text(_user?.username ?? "User", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("${_user?.college ?? 'Student'} • Jodhpur", style: const TextStyle(color: Colors.grey, fontSize: 14)),
        
              const SizedBox(height: 25),
        
              // --- 📊 Seller Stats (Optional for now) ---
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
                        _buildStatItem("Active Ads", "${_stats?['activeAds'] ?? 0}", primaryColor),
                        Container(height: 40, width: 1, color: Colors.grey.shade300),
                        _buildStatItem("Books Sold", "${_stats?['booksSold'] ?? 0}", Colors.black),
                        Container(height: 40, width: 1, color: Colors.grey.shade300),
                        _buildStatItem("Earnings", "₹${_stats?['earnings'] ?? 0}", Colors.green),
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