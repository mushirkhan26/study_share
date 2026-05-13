import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/ui_provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final uiProvider = Provider.of<UIProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.appearance, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader(l10n.appearance, theme),
          
          _buildThemeOption(
            context: context,
            title: l10n.lightMode,
            icon: Icons.light_mode_outlined,
            mode: ThemeMode.light,
            currentMode: uiProvider.themeMode,
            onTap: () => uiProvider.setThemeMode(ThemeMode.light),
            theme: theme,
          ),
          _buildThemeOption(
            context: context,
            title: l10n.darkMode,
            icon: Icons.dark_mode_outlined,
            mode: ThemeMode.dark,
            currentMode: uiProvider.themeMode,
            onTap: () => uiProvider.setThemeMode(ThemeMode.dark),
            theme: theme,
          ),
          _buildThemeOption(
            context: context,
            title: l10n.systemDefault,
            icon: Icons.settings_brightness_outlined,
            mode: ThemeMode.system,
            currentMode: uiProvider.themeMode,
            onTap: () => uiProvider.setThemeMode(ThemeMode.system),
            theme: theme,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Divider(color: theme.dividerColor),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              l10n.darkModeNotice,
              style: TextStyle(color: theme.hintColor, fontSize: 13),
            ),
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

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final bool isSelected = mode == currentMode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : (theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isSelected ? AppColors.primary : theme.hintColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: isSelected 
          ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
          : Icon(Icons.circle_outlined, color: theme.hintColor, size: 24),
      onTap: onTap,
    );
  }
}
