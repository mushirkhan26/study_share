import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/ui_utils.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _imageFile.value = File(pickedFile.path);
    }
  }

  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.updateProfile(
        username: _nameController.text.trim(),
        college: _collegeController.text.trim(),
        profileImage: _imageFile.value,
      );

      if (success) {
        if (context.mounted) {
          UIUtils.showSnackBar(context, "Profile Updated Successfully!");
          context.pop();
        }
      } else {
        if (context.mounted) {
          UIUtils.showSnackBar(context, "Update failed", isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Initialize controllers with current user data
    _nameController.text = user?.username ?? '';
    _collegeController.text = user?.college ?? '';

    if (authProvider.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    ValueListenableBuilder<File?>(
                      valueListenable: _imageFile,
                      builder: (context, file, child) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          backgroundImage: file != null 
                              ? FileImage(file) 
                              : (user?.profileImage != null ? NetworkImage(user!.profileImage!) as ImageProvider : null),
                          child: (file == null && user?.profileImage == null)
                              ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                              : null,
                        );
                      }
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildEditField("Full Name", _nameController, Icons.person_outline),
              const SizedBox(height: 20),
              _buildEditField("College/University", _collegeController, Icons.school_outlined),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : () => _saveProfile(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: authProvider.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          validator: (value) => value!.isEmpty ? "This field is required" : null,
        ),
      ],
    );
  }
}
