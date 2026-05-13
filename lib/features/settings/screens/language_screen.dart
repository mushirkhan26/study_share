import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/ui_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  final List<Map<String, dynamic>> _languages = const [
    {'name': 'English', 'sub': 'Default Language', 'code': 'en'},
    {'name': 'Hindi', 'sub': 'हिन्दी', 'code': 'hi'},
    {'name': 'Spanish', 'sub': 'Español', 'code': 'es'},
    {'name': 'French', 'sub': 'Français', 'code': 'fr'},
    {'name': 'Arabic', 'sub': 'العربية', 'code': 'ar'},
  ];

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("App Language", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("Select Language"),
          
          Expanded(
            child: ListView.builder(
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final lang = _languages[index];
                return _buildLanguageOption(
                  title: lang['name']!,
                  subtitle: lang['sub']!,
                  isSelected: uiProvider.locale.languageCode == lang['code'],
                  onTap: () => uiProvider.setLocale(Locale(lang['code'])),
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Changing the language will update the app's user interface text.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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

  Widget _buildLanguageOption({
    required String title, 
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.language_rounded, 
          color: isSelected ? AppColors.primary : Colors.grey[600], 
          size: 22
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
          color: isSelected ? AppColors.primary : Colors.black87,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: isSelected 
          ? const Icon(Icons.radio_button_checked_rounded, color: AppColors.primary, size: 24)
          : const Icon(Icons.radio_button_off_rounded, color: Colors.grey, size: 24),
      onTap: onTap,
    );
  }
}
