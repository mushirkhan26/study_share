import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/material_provider.dart';
import '../../../widgets/note_card.dart';
import '../../../widgets/skeleton_loaders.dart';

class StudyMaterialsScreen extends StatelessWidget {
  const StudyMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final materialProvider = Provider.of<MaterialProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!materialProvider.hasFetched && !materialProvider.isLoading) {
        materialProvider.fetchMaterials();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Study Materials", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: materialProvider.isLoading && materialProvider.materials.isEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 8,
              itemBuilder: (context, index) => const NoteCardSkeleton(),
            )
          : materialProvider.materials.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => materialProvider.fetchMaterials(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: materialProvider.materials.length,
                    itemBuilder: (context, index) {
                      final item = materialProvider.materials[index];
                      return NoteCard(
                        title: item['title'],
                        subject: item['subject'],
                        author: item['uploader']?['username'] ?? "Anonymous",
                        onTap: () async {
                          final String? fileUrl = item['fileUrl'];
                          if (fileUrl != null && fileUrl.isNotEmpty) {
                            final Uri uri = Uri.parse(fileUrl);
                            try {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } catch (e) {
                              try {
                                await launchUrl(uri, mode: LaunchMode.platformDefault);
                              } catch (e2) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("No app found to open this file")),
                                  );
                                }
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadDialog(context),
        backgroundColor: const Color(0xFF00BFA5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final ValueNotifier<File?> selectedFile = ValueNotifier<File?>(null);
    final ValueNotifier<String> selectedType = ValueNotifier<String>('PDF');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Upload Study Material", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildModalTextField("Title", "e.g. Java Notes", titleController),
              const SizedBox(height: 15),
              _buildModalTextField("Subject", "e.g. Computer Science", subjectController),
              const SizedBox(height: 15),
              const Text("Type", style: TextStyle(fontWeight: FontWeight.bold)),
              ValueListenableBuilder<String>(
                valueListenable: selectedType,
                builder: (context, type, child) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: 'PDF',
                        groupValue: type,
                        onChanged: (v) => selectedType.value = v!,
                      ),
                      const Text("PDF"),
                      Radio<String>(
                        value: 'Image',
                        groupValue: type,
                        onChanged: (v) => selectedType.value = v!,
                      ),
                      const Text("Image"),
                    ],
                  );
                }
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
                  );
                  if (result != null && result.files.single.path != null) {
                    selectedFile.value = File(result.files.single.path!);
                    if (result.files.single.extension?.toLowerCase() == 'pdf') {
                      selectedType.value = 'PDF';
                    } else {
                      selectedType.value = 'Image';
                    }
                  }
                },
                child: ValueListenableBuilder<File?>(
                  valueListenable: selectedFile,
                  builder: (context, file, child) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: file != null
                          ? Center(child: Text("File Selected: ${file.path.split('/').last}"))
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_file, color: Color(0xFF00BFA5)),
                                Text("Tap to select file (Image/PDF)", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Consumer<MaterialProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: provider.isLoading ? null : () async {
                        if (titleController.text.isEmpty || subjectController.text.isEmpty || selectedFile.value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required")));
                          return;
                        }

                        final success = await provider.uploadMaterial(
                          title: titleController.text,
                          subject: subjectController.text,
                          type: selectedType.value,
                          file: selectedFile.value!,
                        );

                        if (success && context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Material Uploaded!")));
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload failed")));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA5)),
                      child: provider.isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Upload Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    );
                  }
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text("No materials shared yet.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
