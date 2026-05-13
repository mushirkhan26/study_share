import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/services/secure_storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // --- Section: Account ---
            _buildSectionHeader(l10n.accountSettings, theme),
            _buildSettingItem(
              icon: Icons.person_outline,
              title: l10n.editProfile,
              onTap: () => context.push(AppRoutes.editProfile),
              theme: theme,
            ),
            _buildSettingItem(
              icon: Icons.notifications_none_rounded,
              title: l10n.notifications,
              onTap: () => context.push(AppRoutes.notifications),
              theme: theme,
            ),
            _buildSettingItem(
              icon: Icons.lock_outline_rounded,
              title: l10n.privacySecurity,
              onTap: () => context.push(AppRoutes.privacySecurity),
              theme: theme,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: theme.dividerColor),
            ),

            // --- Section: App Settings ---
            _buildSectionHeader(l10n.preferences, theme),
            _buildSettingItem(
              icon: Icons.dark_mode_outlined,
              title: l10n.appearance,
              onTap: () => context.push(AppRoutes.appearance),
              theme: theme,
            ),

            _buildSettingItem(
              icon: Icons.language_outlined,
              title: l10n.appLanguage,
              onTap: () => context.push(AppRoutes.language),
              theme: theme,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: theme.dividerColor),
            ),

            // --- Section: Support ---
            _buildSectionHeader(l10n.supportAbout, theme),
            _buildSettingItem(
              icon: Icons.help_outline_rounded,
              title: l10n.helpCenter,
              onTap: () => context.push(AppRoutes.helpCenter),
              theme: theme,
            ),
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: l10n.privacyPolicy,
              onTap: () => context.push(AppRoutes.privacyPolicy),
              theme: theme,
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: l10n.aboutApp,
              onTap: () => context.push(AppRoutes.aboutApp),
              theme: theme,
            ),

            const SizedBox(height: 30),

            // --- Logout Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context, l10n),
                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                  label: Text(l10n.logout, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: theme.hintColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, required VoidCallback onTap, required ThemeData theme}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.hintColor),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final SecureStorageService storage = SecureStorageService();
              await storage.logout();
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                context.go(AppRoutes.loginRoute);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.logout, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
