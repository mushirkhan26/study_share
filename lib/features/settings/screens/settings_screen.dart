import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildSettingItem(Icons.notifications_none, "Notifications", () {}),
          _buildSettingItem(Icons.dark_mode_outlined, "Theme Mode", () {}),
          _buildSettingItem(Icons.privacy_tip_outlined, "Privacy Policy", () {}),
          _buildSettingItem(Icons.info_outline, "About App", () {}),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}