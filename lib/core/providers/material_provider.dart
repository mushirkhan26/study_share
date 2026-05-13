import 'dart:io';
import 'package:flutter/material.dart';
import '../api/network/material_service.dart';

class MaterialProvider extends ChangeNotifier {
  final MaterialService _materialService = MaterialService();

  List<dynamic> _materials = [];
  bool _isLoading = false;
  bool _hasFetched = false;

  List<dynamic> get materials => _materials;
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;

  Future<void> fetchMaterials() async {
    if (!_hasFetched) {
      _isLoading = true;
      notifyListeners();
    }

    final response = await _materialService.getMaterials();
    if (response.success && response.data != null) {
      _materials = response.data!;
    }

    _hasFetched = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> uploadMaterial({
    required String title,
    required String subject,
    String? description,
    required String type,
    required File file,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _materialService.uploadMaterial(
      title: title,
      subject: subject,
      description: description,
      type: type,
      file: file,
    );

    _isLoading = false;
    notifyListeners();

    if (response.success) {
      fetchMaterials();
      return true;
    }
    return false;
  }
}
