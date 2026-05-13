import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String subject;
  final String author;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.title,
    required this.subject,
    required this.author,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // PDF/File Icon
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF00BFA5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf, color: Color(0xFF00BFA5)),
            ),
            const SizedBox(width: 15),
            // Note Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("$subject • By $author", style: TextStyle(color: theme.hintColor, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.hintColor),
          ],
        ),
      ),
    );
  }
}
