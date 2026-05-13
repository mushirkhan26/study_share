import 'dart:io';
import 'package:flutter/material.dart';
import '../api/network/auth_service.dart';
import '../models/user_model.dart';
import '../services/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureStorageService _storage = SecureStorageService();

  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  Map<String, dynamic>? _stats;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  Map<String, dynamic>? get stats => _stats;

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final data = await _storage.getUserData();
      if (data != null) {
        _user = UserModel(
          id: data['userId'] ?? '',
          username: data['username'] ?? 'User',
          email: data['email'] ?? '',
          role: UserRoleExtension.fromString(data['role'] ?? 'buyer'),
          profileImage: data['profileImage'],
          college: data['college'],
        );
      }
    } catch (e) {
      debugPrint("Error loading user from storage: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.login(email: email, password: password);
    
    _isLoading = false;
    if (response.success && response.data != null) {
      _user = response.data;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String college,
    UserRole role = UserRole.buyer,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.signup(
      username: username,
      email: email,
      password: password,
      college: college,
      role: role,
    );

    _isLoading = false;
    if (response.success && response.data != null) {
      _user = response.data;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _storage.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    final response = await _authService.getUserProfile();
    if (response.success && response.data != null) {
      _user = response.data;
      if (_user!.isSeller) {
        final statsResponse = await _authService.getUserStats();
        if (statsResponse.success) {
          _stats = statsResponse.data;
        }
      }
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? username,
    String? college,
    String? role,
    File? profileImage,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.updateProfile(
      username: username,
      college: college,
      role: role,
      profileImage: profileImage,
    );

    _isLoading = false;
    if (response.success && response.data != null) {
      _user = response.data;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }
}
