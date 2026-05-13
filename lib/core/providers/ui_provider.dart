import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  int _navIndex = 0;
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;

  int get navIndex => _navIndex;
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
