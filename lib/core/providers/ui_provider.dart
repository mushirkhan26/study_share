import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

class UIProvider extends ChangeNotifier {
  final SecureStorageService _storage = SecureStorageService();
  int _navIndex = 0;
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;

  UIProvider() {
    _loadThemeFromStorage();
    _loadLocaleFromStorage();
  }

  int get navIndex => _navIndex;
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  Future<void> _loadThemeFromStorage() async {
    final themeString = await _storage.getThemeMode();
    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.light,
      );
      notifyListeners();
    }
  }

  Future<void> _loadLocaleFromStorage() async {
    final languageCode = await _storage.getLanguageCode();
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    await _storage.saveLanguageCode(locale.languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _storage.saveThemeMode(mode.toString());
  }
}
