import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Privacy Policy for Study Share",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              "Last Updated: May 2026",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 25),
            _buildPolicySection(
              "1. Introduction",
              "Welcome to Study Share. We respect your privacy and want to protect your personal data. This Privacy Policy explains how we collect, use, and share your information when you use our mobile application.",
            ),
            _buildPolicySection(
              "2. Data We Collect",
              "We collect information that you provide directly to us, such as when you create an account, post a book advertisement, or communicate with other users. This may include:\n\n• Name and email address\n• Phone number (optional)\n• College or University name\n• Photos of the books you post",
            ),
            _buildPolicySection(
              "3. How We Use Your Data",
              "We use the information we collect to:\n\n• Provide and maintain our services\n• Facilitate connections between buyers and sellers\n• Send you technical notices and support messages\n• Monitor and analyze usage and trends",
            ),
            _buildPolicySection(
              "4. Data Sharing",
              "We do not sell your personal data. We only share information with other users as necessary to facilitate transactions (e.g., showing your name on an ad). Your phone number is only shared if you explicitly choose to enable that setting.",
            ),
            _buildPolicySection(
              "5. Your Rights",
              "You have the right to access, update, or delete your personal information at any time through the app's settings. If you choose to delete your account, all your data will be permanently removed from our servers.",
            ),
            _buildPolicySection(
              "6. Contact Us",
              "If you have any questions about this Privacy Policy, please contact us at support@studyshare.com.",
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Thank you for trusting Study Share.",
                style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.6),
          ),
        ],
      ),
    );
  }
}
