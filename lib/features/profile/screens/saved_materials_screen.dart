import 'package:flutter/material.dart';
import '../../../widgets/note_card.dart';

class SavedMaterialsScreen extends StatelessWidget {
  const SavedMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Materials")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const NoteCard(
            title: "Python Interview Questions",
            subject: "Programming",
            author: "Admin",
          );
        },
      ),
    );
  }
}