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
          phoneNumber: data['phoneNumber'],
          isTwoFactorEnabled: data['isTwoFactorEnabled'] == true || data['isTwoFactorEnabled'] == 'true',
          isPrivateProfile: data['isPrivateProfile'] == true || data['isPrivateProfile'] == 'true',
          showPhoneNumber: data['showPhoneNumber'] == true || data['showPhoneNumber'] == 'true',
        );
      }
    } catch (e) {
      debugPrint("Error loading user from storage: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.login(email: email, password: password);

    _isLoading = false;
    if (response.success && response.data != null) {
      if (response.message == '2FA_REQUIRED') {
        notifyListeners();
        return '2FA_REQUIRED';
      }
      _user = response.data;
      notifyListeners();
      return 'SUCCESS';
    }
    notifyListeners();
    return response.message ?? 'Login failed';
  }

  Future<bool> verify2FA(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.verify2FA(email: email, otp: otp);

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
    String? phoneNumber,
    String? role,
    File? profileImage,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.updateProfile(
      username: username,
      college: college,
      phoneNumber: phoneNumber,
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

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    _isLoading = false;
    notifyListeners();
    return response.success;
  }

  Future<bool> updateSettings({
    bool? isTwoFactorEnabled,
    bool? isPrivateProfile,
    bool? showPhoneNumber,
  }) async {
    final response = await _authService.updateSettings(
      isTwoFactorEnabled: isTwoFactorEnabled,
      isPrivateProfile: isPrivateProfile,
      showPhoneNumber: showPhoneNumber,
    );

    if (response.success && response.data != null) {
      _user = _user?.copyWith(
        isTwoFactorEnabled: response.data!['isTwoFactorEnabled'],
        isPrivateProfile: response.data!['isPrivateProfile'],
        showPhoneNumber: response.data!['showPhoneNumber'],
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<List<dynamic>> getActiveSessions() async {
    final response = await _authService.getActiveSessions();
    if (response.success && response.data != null) {
      return response.data!;
    }
    return [];
  }

  Future<bool> revokeSession(String sessionId) async {
    final response = await _authService.revokeSession(sessionId);
    return response.success;
  }

  Future<bool> deleteAccount() async {
    final response = await _authService.deleteAccount();
    if (response.success) {
      await logout();
      return true;
    }
    return false;
  }

  Future<String?> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    final response = await _authService.forgotPassword(email);
    _isLoading = false;
    notifyListeners();
    return response.success ? null : response.message;
  }

  Future<String?> resetPassword(String email, String otp, String newPassword) async {
    _isLoading = true;
    notifyListeners();
    final response = await _authService.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    _isLoading = false;
    notifyListeners();
    return response.success ? null : response.message;
  }
}
