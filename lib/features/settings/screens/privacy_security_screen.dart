import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Privacy & Security", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            _buildSectionHeader("Security"),
            _buildSecurityItem(
              icon: Icons.lock_reset_rounded,
              title: "Change Password",
              subtitle: "Update your account password regularly",
              onTap: () {
                // Future: Show change password dialog/screen
              },
            ),
            _buildSecurityItem(
              icon: Icons.security_rounded,
              title: "Two-Factor Authentication",
              subtitle: "Add an extra layer of security",
              trailing: Switch(value: false, onChanged: (val) {}, activeColor: AppColors.primary),
              onTap: () {},
            ),
            _buildSecurityItem(
              icon: Icons.devices_rounded,
              title: "Active Sessions",
              subtitle: "Manage devices where you are logged in",
              onTap: () {},
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),

            _buildSectionHeader("Privacy"),
            _buildSecurityItem(
              icon: Icons.visibility_off_outlined,
              title: "Private Profile",
              subtitle: "Only show your ads to registered users",
              trailing: Switch(value: true, onChanged: (val) {}, activeColor: AppColors.primary),
              onTap: () {},
            ),
            _buildSecurityItem(
              icon: Icons.contact_mail_outlined,
              title: "Show Phone Number",
              subtitle: "Allow buyers to see your number",
              trailing: Switch(value: false, onChanged: (val) {}, activeColor: AppColors.primary),
              onTap: () {},
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),

            _buildSectionHeader("Account Action"),
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
              title: const Text("Delete Account", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.red)),
              subtitle: const Text("Permanently remove your account and data", style: TextStyle(fontSize: 12)),
              onTap: () {
                // Future: Show account deletion confirmation
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
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
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
