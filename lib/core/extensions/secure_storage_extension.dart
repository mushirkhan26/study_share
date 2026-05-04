import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

extension SecureStorageExtensions on BuildContext {

  /// User ID nikalne ke liye
  Future<String?> getUserId() async {
    final userData = await SecureStorageService().getUserData();
    return userData?['userId']; //modelsuserId
  }

  /// Username nikalne ke liye (Jaise: Bhanja Warrior)
  Future<String?> getUsername() async {
    final userData = await SecureStorageService().getUserData();
    return userData?['username'];
  }

  /// Email nikalne ke liye
  Future<String?> getUserEmail() async {
    final userData = await SecureStorageService().getUserData();
    return userData?['email'];
  }

  /// Pura data ek saath nikalne ke liye
  Future<Map<String, dynamic>?> getUserData() async {
    return await SecureStorageService().getUserData();
  }
}