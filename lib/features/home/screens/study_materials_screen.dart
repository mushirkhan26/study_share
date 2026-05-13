import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/material_provider.dart';
import '../../../widgets/note_card.dart';
import '../../../widgets/skeleton_loaders.dart';

class StudyMaterialsScreen extends StatelessWidget {
  const StudyMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final materialProvider = Provider.of<MaterialProvider>(context);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!materialProvider.hasFetched && !materialProvider.isLoading) {
        materialProvider.fetchMaterials();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.studyMaterials, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: materialProvider.isLoading && materialProvider.materials.isEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 8,
              itemBuilder: (context, index) => const NoteCardSkeleton(),
            )
          : materialProvider.materials.isEmpty
              ? _buildEmptyState(theme, l10n)
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
                                    SnackBar(content: Text(l10n.noAppToOpenFile)),
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
        onPressed: () => _showUploadDialog(context, l10n),
        backgroundColor: const Color(0xFF00BFA5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showUploadDialog(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final ValueNotifier<File?> selectedFile = ValueNotifier<File?>(null);
    final ValueNotifier<String> selectedType = ValueNotifier<String>('PDF');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
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
              Text(l10n.uploadStudyMaterial, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildModalTextField(l10n.bookTitle, l10n.titleHint, titleController, theme),
              const SizedBox(height: 15),
              _buildModalTextField(l10n.subject, l10n.subjectHint, subjectController, theme),
              const SizedBox(height: 15),
              Text(l10n.type, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      Text(l10n.pdf),
                      Radio<String>(
                        value: 'Image',
                        groupValue: type,
                        onChanged: (v) => selectedType.value = v!,
                      ),
                      Text(l10n.image),
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
                        color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: file != null
                          ? Center(child: Text(l10n.fileSelected(file.path.split('/').last)))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.upload_file, color: Color(0xFF00BFA5)),
                                Text(l10n.tapToSelectFile, style: const TextStyle(fontSize: 12)),
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.allFieldsRequired)));
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.materialUploaded)));
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.uploadFailed)));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA5)),
                      child: provider.isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.uploadNow, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildModalTextField(String label, String hint, TextEditingController controller, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.hintColor),
            filled: true,
            fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 80, color: theme.dividerColor),
          const SizedBox(height: 15),
          Text(l10n.noMaterialsShared, style: TextStyle(color: theme.hintColor, fontSize: 16)),
        ],
      ),
    );
  }
}
