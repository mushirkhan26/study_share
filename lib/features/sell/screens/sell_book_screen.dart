import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/book_provider.dart';
import '../../../core/utils/ui_utils.dart';

class SellBookScreen extends StatelessWidget {
  SellBookScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<List<XFile>> _imageFiles = ValueNotifier<List<XFile>>([]);
  final ValueNotifier<int> _frontImageIndex = ValueNotifier<int>(0);
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Dropdown Values
  final ValueNotifier<String> _selectedCondition = ValueNotifier<String>('Good');
  final ValueNotifier<String> _selectedTag = ValueNotifier<String>('BCA');

  final List<String> _conditions = ['Like New', 'Good', 'Old', 'Worn Out'];
  final List<String> _tags = ['BCA', 'B.Tech', 'B.Sc', 'BA', 'Novels', 'Other'];

  String _getConditionLabel(String condition, AppLocalizations l10n) {
    switch (condition) {
      case 'Like New': return l10n.likeNew;
      case 'Good': return l10n.good;
      case 'Old': return l10n.old;
      case 'Worn Out': return l10n.wornOut;
      default: return condition;
    }
  }

  String _getTagLabel(String tag, AppLocalizations l10n) {
    switch (tag) {
      case 'BCA': return l10n.bca;
      case 'B.Tech': return l10n.btech;
      case 'B.Sc': return l10n.bsc;
      case 'BA': return l10n.ba;
      case 'Novels': return l10n.novels;
      case 'Other': return l10n.other;
      default: return tag;
    }
  }

  Future<void> _pickImage(BuildContext context, AppLocalizations l10n) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.selectSource, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(context, Icons.camera_alt_rounded, l10n.camera, ImageSource.camera),
                _buildSourceOption(context, Icons.photo_library_rounded, l10n.gallery, ImageSource.gallery),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(BuildContext context, IconData icon, String label, ImageSource source) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
        if (pickedFile != null) {
          if (_imageFiles.value.length < 3) {
            _imageFiles.value = [..._imageFiles.value, pickedFile];
          }
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

  void _submitAd(BuildContext context, AppLocalizations l10n) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    if (bookProvider.isLoading) return;

    if (_formKey.currentState!.validate()) {
      if (_imageFiles.value.isEmpty) {
        UIUtils.showSnackBar(context, l10n.pleaseUploadPhoto, isError: true);
        return;
      }

      // Reorder images so that the front image is at index 0
      List<XFile> finalImages = List.from(_imageFiles.value);
      if (_frontImageIndex.value != 0 && _frontImageIndex.value < finalImages.length) {
        final frontImage = finalImages.removeAt(_frontImageIndex.value);
        finalImages.insert(0, frontImage);
      }

      final success = await bookProvider.uploadBook(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        sellingPrice: double.parse(_sellingPriceController.text),
        originalPrice: double.parse(_originalPriceController.text),
        condition: _selectedCondition.value,
        tag: _selectedTag.value,
        description: _descriptionController.text.trim(),
        imageFiles: finalImages.map((file) => File(file.path)).toList(),
      );

      if (success) {
        if (context.mounted) {
          UIUtils.showSnackBar(context, l10n.adPostedSuccess);
          _titleController.clear();
          _authorController.clear();
          _sellingPriceController.clear();
          _originalPriceController.clear();
          _descriptionController.clear();
          _imageFiles.value = [];
          _frontImageIndex.value = 0;
        }
      } else {
        if (context.mounted) {
          UIUtils.showSnackBar(context, l10n.failedToPostAd, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);
    final user = authProvider.user;

    if (authProvider.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null || user.isBuyer) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(l10n.postBook, style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_person_outlined, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                Text(
                  l10n.sellerProfileRequired,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.buyerProfileNotice,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.hintColor, fontSize: 16),
                ),
                const SizedBox(height: 30),
                  SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.switchToSellerConfirm),
                          content: Text(l10n.switchToSellerNotice),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.switchText, style: const TextStyle(color: Color(0xFF00BFA5)))),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        final success = await authProvider.updateProfile(role: 'seller');
                        if (success && context.mounted) {
                           UIUtils.showSnackBar(context, l10n.accountUpgraded);
                        } else if (context.mounted) {
                           UIUtils.showSnackBar(context, l10n.failedToUpgrade, isError: true);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: authProvider.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(l10n.switchToSeller, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.postBook, style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📸 Photo Upload Box
              Text(l10n.bookPhoto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ValueListenableBuilder<List<XFile>>(
                valueListenable: _imageFiles,
                builder: (context, files, child) {
                  if (files.isEmpty) {
                    return GestureDetector(
                      onTap: () => _pickImage(context, l10n),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF00BFA5), style: BorderStyle.solid, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined, size: 40, color: Color(0xFF00BFA5)),
                            const SizedBox(height: 8),
                            Text(l10n.tapToAddPhoto, style: TextStyle(color: theme.hintColor)),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length < 3 ? files.length + 1 : 3,
                          itemBuilder: (context, index) {
                            if (index == files.length && files.length < 3) {
                              return GestureDetector(
                                onTap: () => _pickImage(context, l10n),
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: const Color(0xFF00BFA5), style: BorderStyle.solid, width: 1.5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF00BFA5)),
                                      const SizedBox(height: 4),
                                      Text(l10n.addMorePhotos, style: TextStyle(fontSize: 10, color: theme.hintColor), textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Stack(
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: _frontImageIndex,
                                  builder: (context, frontIndex, _) {
                                    bool isFront = frontIndex == index;
                                    return GestureDetector(
                                      onTap: () => _frontImageIndex.value = index,
                                      child: Container(
                                        width: 120,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: isFront ? const Color(0xFF00BFA5) : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(13),
                                          child: Image.file(File(files[index].path), fit: BoxFit.cover),
                                        ),
                                      ),
                                    );
                                  }
                                ),
                                Positioned(
                                  top: 5,
                                  right: 15,
                                  child: GestureDetector(
                                    onTap: () {
                                      List<XFile> newList = List.from(_imageFiles.value);
                                      newList.removeAt(index);
                                      _imageFiles.value = newList;
                                      if (_frontImageIndex.value >= newList.length) {
                                        _frontImageIndex.value = 0;
                                      }
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                                ValueListenableBuilder<int>(
                                  valueListenable: _frontImageIndex,
                                  builder: (context, frontIndex, _) {
                                    if (frontIndex != index) return const SizedBox.shrink();
                                    return Positioned(
                                      bottom: 5,
                                      left: 5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00BFA5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          l10n.frontPhoto,
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.selectFrontPhoto, style: TextStyle(fontSize: 12, color: theme.hintColor)),
                    ],
                  );
                }
              ),

              const SizedBox(height: 25),

              // 📝 Book Details
              Text(l10n.bookDetails, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _buildTextField(l10n.bookTitle, l10n.titleHint, _titleController, Icons.book, theme: theme, l10n: l10n),
              const SizedBox(height: 15),
              _buildTextField(l10n.authorName, l10n.authorHint, _authorController, Icons.person_outline, theme: theme, l10n: l10n),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(l10n.sellingPrice, l10n.priceHint, _sellingPriceController, Icons.currency_rupee, isNumber: true, theme: theme, l10n: l10n),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTextField(l10n.originalPrice, l10n.originalPriceHint, _originalPriceController, Icons.price_change_outlined, isNumber: true, theme: theme, l10n: l10n),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _selectedCondition,
                      builder: (context, value, child) {
                        return _buildDropdown(l10n.condition, value, _conditions, (val) {
                          _selectedCondition.value = val!;
                        }, theme: theme, l10n: l10n);
                      }
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _selectedTag,
                      builder: (context, value, child) {
                        return _buildDropdown(l10n.courseTag, value, _tags, (val) {
                          _selectedTag.value = val!;
                        }, theme: theme, l10n: l10n);
                      }
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Text(l10n.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _buildTextField(
                l10n.description, 
                l10n.descriptionHint, 
                _descriptionController, 
                Icons.description_outlined,
                maxLines: 4,
                theme: theme,
                l10n: l10n,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: bookProvider.isLoading ? null : () => _submitAd(context, l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: bookProvider.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(l10n.postAd, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon, {bool isNumber = false, int maxLines = 1, required ThemeData theme, required AppLocalizations l10n}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      maxLines: maxLines,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.hintColor),
        hintText: hint,
        hintStyle: TextStyle(color: theme.hintColor),
        prefixIcon: Icon(icon, color: const Color(0xFF00BFA5), size: 20),
        filled: true,
        fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? l10n.required : null,
    );
  }

  Widget _buildDropdown(String label, String currentValue, List<String> items, Function(String?) onChanged, {required ThemeData theme, required AppLocalizations l10n}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: theme.hintColor, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: currentValue,
              dropdownColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
              items: items.map((String value) {
                String translatedValue = value;
                if (label == l10n.condition) translatedValue = _getConditionLabel(value, l10n);
                if (label == l10n.courseTag) translatedValue = _getTagLabel(value, l10n);
                return DropdownMenuItem<String>(value: value, child: Text(translatedValue, style: TextStyle(color: theme.textTheme.bodyLarge?.color)));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
