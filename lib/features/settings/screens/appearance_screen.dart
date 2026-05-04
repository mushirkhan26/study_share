import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  // Current selected mode (Dummy state for now)
  String _selectedTheme = 'System Default';

  @override
  Widget build(BuildContext context) {
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
            title: "Light Mode",
            icon: Icons.light_mode_outlined,
            value: "Light Mode",
          ),
          _buildThemeOption(
            title: "Dark Mode",
            icon: Icons.dark_mode_outlined,
            value: "Dark Mode",
          ),
          _buildThemeOption(
            title: "System Default",
            icon: Icons.settings_brightness_outlined,
            value: "System Default",
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

  Widget _buildThemeOption({required String title, required IconData icon, required String value}) {
    final bool isSelected = _selectedTheme == value;

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
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
        // Future: Implement actual theme switching logic using a Provider or Bloc
      },
    );
  }
}
