import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/models/user_model.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/api/network/auth_service.dart';
import '../../../core/api/network/book_service.dart';
import '../../../core/utils/ui_utils.dart';

class SellBookScreen extends StatefulWidget {
  const SellBookScreen({super.key});

  @override
  State<SellBookScreen> createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final SecureStorageService _storage = SecureStorageService();
  final BookService _bookService = BookService();
  final AuthService _authService = AuthService();
  bool _isSubmitting = false;
  bool _isLoadingRole = true;
  UserModel? _currentUser;

  // Image Picker
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Dropdown Values
  String _selectedCondition = 'Good';
  String _selectedTag = 'BCA';

  final List<String> _conditions = ['Like New', 'Good', 'Old', 'Worn Out'];
  final List<String> _tags = ['BCA', 'B.Tech', 'B.Sc', 'BA', 'Novels', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final data = await _storage.getUserData();
    if (data != null) {
      setState(() {
        _currentUser = UserModel(
          id: data['userId'] ?? '',
          username: data['username'] ?? 'User',
          email: data['email'] ?? '',
          role: UserRoleExtension.fromString(data['role'] ?? 'buyer'),
        );
        _isLoadingRole = false;
      });
    } else {
      setState(() => _isLoadingRole = false);
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select Source", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(Icons.camera_alt_rounded, "Camera", ImageSource.camera),
                _buildSourceOption(Icons.photo_library_rounded, "Gallery", ImageSource.gallery),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
        if (pickedFile != null) {
          setState(() => _imageFile = pickedFile);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF00BFA5).withValues(alpha: 0.1),
            child: Icon(icon, color: const Color(0xFF00BFA5), size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _submitAd() async {
    print('Submit Ad button pressed');
    if (_isSubmitting) {
      print('Already submitting, ignoring press');
      return;
    }

    if (_formKey.currentState!.validate()) {
      print('Form validated successfully');
      if (_imageFile == null) {
        print('Image file is null');
        UIUtils.showSnackBar(context, "Please upload a picture of the book!", isError: true);
        return;
      }

      setState(() => _isSubmitting = true);

      final response = await _bookService.uploadBook(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        sellingPrice: double.parse(_sellingPriceController.text),
        originalPrice: double.parse(_originalPriceController.text),
        condition: _selectedCondition,
        tag: _selectedTag,
        description: _descriptionController.text.trim(),
        imageFile: File(_imageFile!.path),
      );

      setState(() => _isSubmitting = false);

      if (response.success) {
        if (mounted) {
          UIUtils.showSnackBar(context, "Book Ad Posted Successfully!");
          // Clear Form
          _titleController.clear();
          _authorController.clear();
          _sellingPriceController.clear();
          _originalPriceController.clear();
          _descriptionController.clear();
          setState(() => _imageFile = null);
        }
      } else {
        if (mounted) {
          UIUtils.showSnackBar(context, response.message ?? "Failed to post ad", isError: true);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _sellingPriceController.dispose();
    _originalPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRole) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentUser == null || _currentUser!.isBuyer) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Post a Book", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_person_outlined, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                const Text(
                  "Seller Profile Required",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You are currently using a Buyer profile. Switch to a Seller profile to post ads and sell your books.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 30),
                  SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Show confirmation dialog or update role directly
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Switch to Seller Profile?"),
                          content: const Text("By switching to a seller profile, you will be able to post book ads and sell your materials to other students."),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Switch", style: TextStyle(color: Color(0xFF00BFA5)))),
                          ],
                        ),
                      );

                      if (confirmed == true && mounted) {
                        setState(() => _isLoadingRole = true);
                        final response = await _authService.updateProfile(role: 'seller');
                        
                        if (response.success) {
                          await _loadUserRole();
                          if (mounted) UIUtils.showSnackBar(context, "Account upgraded to Seller!");
                        } else {
                          setState(() => _isLoadingRole = false);
                          if (mounted) UIUtils.showSnackBar(context, response.message ?? "Failed to upgrade", isError: true);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Switch to Seller Profile", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Post a Book", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📸 Photo Upload Box
              const Text("Book Photo *", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF00BFA5), style: BorderStyle.solid, width: 1.5),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                  )
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 40, color: Color(0xFF00BFA5)),
                      SizedBox(height: 8),
                      Text("Tap to add cover photo", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 📝 Book Details
              const Text("Book Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _buildTextField("Book Title", "e.g. Let Us C", _titleController, Icons.book),
              const SizedBox(height: 15),
              _buildTextField("Author Name", "e.g. Yashavant Kanetkar", _authorController, Icons.person_outline),

              const SizedBox(height: 25),

              // 💰 Prices (Row mein taaki jagah bache)
              Row(
                children: [
                  Expanded(
                    child: _buildTextField("Selling Price (₹)", "e.g. 150", _sellingPriceController, Icons.currency_rupee, isNumber: true),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTextField("Original Price (₹)", "e.g. 400", _originalPriceController, Icons.price_change_outlined, isNumber: true),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🏷️ Condition & Tag Dropdowns
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown("Condition", _selectedCondition, _conditions, (val) {
                      setState(() => _selectedCondition = val!);
                    }),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDropdown("Course/Tag", _selectedTag, _tags, (val) {
                      setState(() => _selectedTag = val!);
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 📖 Description
              const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildTextField(
                "Tell us more about the book", 
                "e.g. Include details about marks, highlights, or why you're selling.", 
                _descriptionController, 
                Icons.description_outlined,
                maxLines: 4,
              ),

              const SizedBox(height: 40),

              // 🚀 Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitAd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Post Ad", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 80), // Bottom nav bar space
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: TextField
  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF00BFA5), size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? "Required" : null,
    );
  }

  // Helper Widget: Dropdown
  Widget _buildDropdown(String label, String currentValue, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: currentValue,
              items: items.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}