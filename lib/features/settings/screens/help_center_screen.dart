import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  List<Map<String, dynamic>> _getFaqs(AppLocalizations l10n) {
    return [
      {
        "category": l10n.general,
        "questions": [
          {
            "q": "What is Study Share?",
            "a": "Study Share is a platform for students to buy, sell, and share second-hand study materials like books, notes, and guides."
          },
          {
            "q": "Is the app free to use?",
            "a": "Yes, browsing and posting ads on Study Share is completely free for all students."
          }
        ]
      },
      {
        "category": l10n.buying,
        "questions": [
          {
            "q": "How do I buy a book?",
            "a": "Find a book you like, click on it to see details, and use the 'Chat with Seller' button to negotiate and arrange the purchase."
          },
          {
            "q": "Can I pay through the app?",
            "a": "Currently, we only facilitate the connection between buyers and sellers. Payments should be handled directly between both parties."
          }
        ]
      },
      {
        "category": l10n.selling,
        "questions": [
          {
            "q": "How do I post an ad?",
            "a": "Go to the 'Sell' tab, upload a photo of your book, fill in the details and price, and click 'Post Ad'."
          },
          {
            "q": "How many ads can I post?",
            "a": "You can post as many ads as you want, as long as they follow our community guidelines."
          }
        ]
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final faqs = _getFaqs(l10n);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.helpCenter, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary.withValues(alpha: 0.05),
              child: Column(
                children: [
                  Text(
                    l10n.howCanWeHelp,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: l10n.searchHelpArticles,
                      hintStyle: TextStyle(color: theme.hintColor),
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      filled: true,
                      fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: faqs.map((category) => _buildFaqCategory(category, theme)).toList(),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: theme.dividerColor),
            ),
            _buildContactCard(theme, l10n),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqCategory(Map<String, dynamic> category, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Text(
            category['category'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        ... (category['questions'] as List).map((qna) => ExpansionTile(
          title: Text(qna['q'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
          iconColor: AppColors.primary,
          collapsedIconColor: theme.hintColor,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                qna['a'],
                style: TextStyle(color: theme.hintColor, fontSize: 14, height: 1.4),
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildContactCard(ThemeData theme, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Text(l10n.stillHaveQuestions, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            l10n.contactSupportNotice,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.hintColor, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.email_outlined, color: Colors.white),
            label: Text(l10n.contactSupport, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
