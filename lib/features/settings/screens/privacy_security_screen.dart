import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../config/navigation/app_routes.dart';
import '../widgets/change_password_dialog.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.privacySecurity, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          if (user == null) return const Center(child: CircularProgressIndicator());

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                _buildSectionHeader(l10n.security, theme),
                _buildSecurityItem(
                  context: context,
                  icon: Icons.lock_reset_rounded,
                  title: l10n.changePassword,
                  subtitle: l10n.changePasswordSubtitle,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ChangePasswordDialog(),
                    );
                  },
                ),
                _buildSecurityItem(
                  context: context,
                  icon: Icons.security_rounded,
                  title: l10n.twoFactorAuth,
                  subtitle: l10n.twoFactorSubtitle,
                  trailing: Switch(
                    value: user.isTwoFactorEnabled, 
                    onChanged: (val) {
                      authProvider.updateSettings(isTwoFactorEnabled: val);
                    }, 
                    activeColor: AppColors.primary
                  ),
                  onTap: () {},
                ),
                _buildSecurityItem(
                  context: context,
                  icon: Icons.devices_rounded,
                  title: l10n.activeSessions,
                  subtitle: l10n.activeSessionsSubtitle,
                  onTap: () => context.push(AppRoutes.activeSessions),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: theme.dividerColor),
                ),

                _buildSectionHeader(l10n.privacy, theme),
                _buildSecurityItem(
                  context: context,
                  icon: Icons.visibility_off_outlined,
                  title: l10n.privateProfile,
                  subtitle: l10n.privateProfileSubtitle,
                  trailing: Switch(
                    value: user.isPrivateProfile, 
                    onChanged: (val) {
                      authProvider.updateSettings(isPrivateProfile: val);
                    }, 
                    activeColor: AppColors.primary
                  ),
                  onTap: () {},
                ),
                _buildSecurityItem(
                  context: context,
                  icon: Icons.contact_mail_outlined,
                  title: l10n.showPhoneNumber,
                  subtitle: l10n.showPhoneNumberSubtitle,
                  trailing: Switch(
                    value: user.showPhoneNumber, 
                    onChanged: (val) {
                      authProvider.updateSettings(showPhoneNumber: val);
                    }, 
                    activeColor: AppColors.primary
                  ),
                  onTap: () {},
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: theme.dividerColor),
                ),

                _buildSectionHeader(l10n.accountAction, theme),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 22),
                  ),
                  title: Text(l10n.deleteAccount, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.red)),
                  subtitle: Text(l10n.deleteAccountSubtitle, style: TextStyle(fontSize: 12, color: theme.hintColor)),
                  onTap: () => _showDeleteConfirmation(context, authProvider, l10n),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AuthProvider authProvider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountConfirmTitle, style: const TextStyle(color: Colors.red)),
        content: Text(l10n.deleteAccountConfirmContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await authProvider.deleteAccount();
              if (success && context.mounted) {
                context.go(AppRoutes.loginRoute);
              }
            }, 
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red))
          ),
        ],
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

  Widget _buildSecurityItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.hintColor)),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14, color: theme.hintColor),
      onTap: onTap,
    );
  }
}
