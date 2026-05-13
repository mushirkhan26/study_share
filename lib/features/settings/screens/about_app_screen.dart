import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.aboutApp, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // --- App Logo & Version ---
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.school_rounded, size: 60, color: AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.appName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Version ${AppConstants.appVersion}",
                    style: TextStyle(color: theme.hintColor, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- Mission Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.ourMission,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.missionDescription,
                    style: TextStyle(fontSize: 15, color: theme.textTheme.bodyMedium?.color, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- Team Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.ourTeam,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildTeamMember("Mushir Khan", "Flutter Developer", Icons.code_rounded, theme),
                  _buildTeamMember("Rehan Qadri", "Backend Developer", Icons.storage_rounded, theme),
                  _buildTeamMember("Mohammed Rehan", "UI Designer", Icons.palette_rounded, theme),
                  _buildTeamMember("Mohammed Sajid", "Application Tester", Icons.bug_report_rounded, theme),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- Bottom Links/Info ---
            Text(
              l10n.madeWithLove,
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, IconData icon, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                role,
                style: TextStyle(color: theme.hintColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
