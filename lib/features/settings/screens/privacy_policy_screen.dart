import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.privacyPolicy, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.privacyPolicyTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.lastUpdated,
              style: TextStyle(color: theme.hintColor, fontSize: 14),
            ),
            const SizedBox(height: 25),
            _buildPolicySection(
              l10n.policyIntroTitle,
              l10n.policyIntroContent,
              theme,
            ),
            _buildPolicySection(
              l10n.policyDataTitle,
              l10n.policyDataContent,
              theme,
            ),
            _buildPolicySection(
              l10n.policyUsageTitle,
              l10n.policyUsageContent,
              theme,
            ),
            _buildPolicySection(
              l10n.policySharingTitle,
              l10n.policySharingContent,
              theme,
            ),
            _buildPolicySection(
              l10n.policyRightsTitle,
              l10n.policyRightsContent,
              theme,
            ),
            _buildPolicySection(
              l10n.policyContactTitle,
              l10n.policyContactContent,
              theme,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                l10n.thankYouTrusting,
                style: TextStyle(color: theme.hintColor, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 15, color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8), height: 1.6),
          ),
        ],
      ),
    );
  }
}
