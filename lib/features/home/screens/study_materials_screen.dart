import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/api/network/material_service.dart';
import '../../../widgets/note_card.dart';

class StudyMaterialsScreen extends StatefulWidget {
  const StudyMaterialsScreen({super.key});

  @override
  State<StudyMaterialsScreen> createState() => _StudyMaterialsScreenState();
}

class _StudyMaterialsScreenState extends State<StudyMaterialsScreen> {
  final MaterialService _materialService = MaterialService();
  List<dynamic> _materials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterials();
  }

  Future<void> _fetchMaterials() async {
    setState(() => _isLoading = true);
    final response = await _materialService.getMaterials();
    if (response.success && response.data != null) {
      setState(() {
        _materials = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Study Materials", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _materials.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _fetchMaterials,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _materials.length,
                    itemBuilder: (context, index) {
                      final item = _materials[index];
                      return NoteCard(
                        title: item['title'],
                        subject: item['subject'],
                        author: item['uploader']?['username'] ?? "Anonymous",
                        onTap: () async {
                          final String? fileUrl = item['fileUrl'];
                          if (fileUrl != null && fileUrl.isNotEmpty) {
                            final Uri uri = Uri.parse(fileUrl);
                            try {
                              // Try direct launch first as canLaunchUrl is flaky on some devices/emulators
                              bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                              if (!launched && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Could not open file in external app")),
                                );
                              }
                            } catch (e) {
                              print("Error launching URL: $e");
                              // Fallback attempt
                              try {
                                await launchUrl(uri, mode: LaunchMode.platformDefault);
                              } catch (e2) {
                                if (mounted) {
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
        onPressed: () {
          _showUploadDialog();
        },
        backgroundColor: const Color(0xFF00BFA5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showUploadDialog() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    File? selectedFile;
    String selectedType = 'PDF';
    bool isUploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                Row(
                  children: [
                    Radio<String>(
                      value: 'PDF',
                      groupValue: selectedType,
                      onChanged: (v) => setModalState(() => selectedType = v!),
                    ),
                    const Text("PDF"),
                    Radio<String>(
                      value: 'Image',
                      groupValue: selectedType,
                      onChanged: (v) => setModalState(() => selectedType = v!),
                    ),
                    const Text("Image"),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
                    );
                    if (result != null && result.files.single.path != null) {
                      setModalState(() => selectedFile = File(result.files.single.path!));
                      // Auto-detect type
                      if (result.files.single.extension?.toLowerCase() == 'pdf') {
                        setModalState(() => selectedType = 'PDF');
                      } else {
                        setModalState(() => selectedType = 'Image');
                      }
                    }
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: selectedFile != null
                        ? Center(child: Text("File Selected: ${selectedFile!.path.split('/').last}"))
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file, color: Color(0xFF00BFA5)),
                              Text("Tap to select file (Image/PDF)", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isUploading ? null : () async {
                      if (titleController.text.isEmpty || subjectController.text.isEmpty || selectedFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required")));
                        return;
                      }

                      setModalState(() => isUploading = true);
                      final res = await _materialService.uploadMaterial(
                        title: titleController.text,
                        subject: subjectController.text,
                        type: selectedType,
                        file: selectedFile!,
                      );
                      setModalState(() => isUploading = false);

                      if (res.success) {
                        Navigator.pop(context);
                        _fetchMaterials();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Material Uploaded!")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Upload failed")));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFA5)),
                    child: isUploading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Upload Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
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
