import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/ui_provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Appearance", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("Theme Mode"),
          
          _buildThemeOption(
            context: context,
            title: "Light Mode",
            icon: Icons.light_mode_outlined,
            mode: ThemeMode.light,
            currentMode: uiProvider.themeMode,
            onTap: () => uiProvider.setThemeMode(ThemeMode.light),
          ),
          _buildThemeOption(
            context: context,
            title: "Dark Mode",
            icon: Icons.dark_mode_outlined,
            mode: ThemeMode.dark,
            currentMode: uiProvider.themeMode,
            onTap: () => uiProvider.setThemeMode(ThemeMode.dark),
          ),
          _buildThemeOption(
            context: context,
            title: "System Default",
            icon: Icons.settings_brightness_outlined,
            mode: ThemeMode.system,
            currentMode: uiProvider.themeMode,
            onTap: () => uiProvider.setThemeMode(ThemeMode.system),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Divider(),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Dark mode helps reduce eye strain and saves battery on OLED screens.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
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

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onTap,
  }) {
    final bool isSelected = mode == currentMode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey[600], size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
          color: isSelected ? AppColors.primary : Colors.black87,
        ),
      ),
      trailing: isSelected 
          ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
          : const Icon(Icons.circle_outlined, color: Colors.grey, size: 24),
      onTap: onTap,
    );
  }
}
