import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/ui_utils.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _phoneController = TextEditingController();
  
  final ValueNotifier<File?> _imageFile = ValueNotifier<File?>(null);

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      _imageFile.value = File(pickedFile.path);
    }
  }

  void _saveProfile(BuildContext context, AppLocalizations l10n) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.updateProfile(
        username: _nameController.text.trim(),
        college: _collegeController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        profileImage: _imageFile.value,
      );

      if (success) {
        if (context.mounted) {
          UIUtils.showSnackBar(context, l10n.profileUpdated);
          context.pop();
        }
      } else {
        if (context.mounted) {
          UIUtils.showSnackBar(context, l10n.updateFailed, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (_nameController.text.isEmpty && user != null) {
      _nameController.text = user.username ?? '';
      _collegeController.text = user.college ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }

    if (authProvider.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.editProfile, style: const TextStyle(fontWeight: FontWeight.bold)),
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

              _buildEditField(context, l10n.fullName, _nameController, Icons.person_outline, l10n: l10n),
              const SizedBox(height: 20),
              _buildEditField(context, l10n.college, _collegeController, Icons.school_outlined, l10n: l10n),
              const SizedBox(height: 20),
              _buildEditField(context, l10n.showPhoneNumber, _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone, l10n: l10n),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : () => _saveProfile(context, l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: authProvider.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        l10n.saveChanges,
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(BuildContext context, String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, required AppLocalizations l10n}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
            filled: true,
            fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          validator: (value) => value!.isEmpty ? l10n.fieldRequired : null,
        ),
      ],
    );
  }
}
