import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SellBookScreen extends StatefulWidget {
  const SellBookScreen({super.key});

  @override
  State<SellBookScreen> createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  final _formKey = GlobalKey<FormState>();

  // Image Picker
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _originalPriceController = TextEditingController();

  // Dropdown Values
  String _selectedCondition = 'Good';
  String _selectedTag = 'BCA';

  final List<String> _conditions = ['Like New', 'Good', 'Old', 'Worn Out'];
  final List<String> _tags = ['BCA', 'B.Tech', 'B.Sc', 'BA', 'Novels', 'Other'];

  Future<void> _pickImage() async {
    // Gallery se image pick karne ka logic
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _submitAd() {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload a picture of the book!")),
        );
        return;
      }

      // TODO: Backend upload logic yahan aayega
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book Ad Posted Successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
      );

      // Form reset or navigate back
    }
  }

  @override
  Widget build(BuildContext context) {
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

              const SizedBox(height: 40),

              // 🚀 Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitAd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Post Ad", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
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
  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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