import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(l10n.myAccount, style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
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
              Text("${user?.college ?? 'Student'} • Jodhpur", style: TextStyle(color: theme.hintColor, fontSize: 14)),
        
              const SizedBox(height: 25),
        
              // --- 📊 Seller Stats ---
              if (isSeller)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(l10n.activeAds, "${stats?['activeAds'] ?? 0}", primaryColor, theme),
                        Container(height: 40, width: 1, color: theme.dividerColor),
                        _buildStatItem(l10n.booksSold, "${stats?['booksSold'] ?? 0}", theme.brightness == Brightness.dark ? Colors.white : Colors.black, theme),
                        Container(height: 40, width: 1, color: theme.dividerColor),
                        _buildStatItem(l10n.earnings, "₹${stats?['earnings'] ?? 0}", Colors.green, theme),
                      ],
                    ),
                  ),
                ),
        
              const SizedBox(height: 30),
              Divider(thickness: 1, color: theme.dividerColor),
        
              // --- ⚙️ Menu Options ---
              if (isSeller)
                _buildProfileTile(
                  icon: Icons.inventory_2_outlined,
                  title: l10n.myAdsManage,
                  subtitle: l10n.myAdsSubtitle,
                  onTap: () => context.push(AppRoutes.myUploads),
                  theme: theme,
                ),
              _buildProfileTile(
                icon: Icons.favorite_border,
                title: l10n.wishlist,
                subtitle: l10n.wishlistSubtitle,
                onTap: () => context.push(AppRoutes.savedMaterials),
                theme: theme,
              ),
              _buildProfileTile(
                icon: Icons.chat_bubble_outline,
                title: l10n.myChats,
                subtitle: l10n.myChatsSubtitle,
                onTap: () => context.push(AppRoutes.inboxRoute),
                theme: theme,
              ),
              _buildProfileTile(
                icon: Icons.settings_outlined,
                title: l10n.settings,
                subtitle: l10n.settingsSubtitle,
                onTap: () => context.push(AppRoutes.settings),
                theme: theme,
              ),
        
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor, ThemeData theme) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: theme.hintColor, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildProfileTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap, required ThemeData theme}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF00BFA5).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child:  Icon(icon, color: Color(0xFF00BFA5)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.hintColor)),
      trailing: Icon(Icons.chevron_right, size: 20, color: theme.hintColor),
      onTap: onTap,
    );
  }
}
