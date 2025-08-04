import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeViewModel extends ChangeNotifier {
  final SharedPreferences? _prefs;
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  ThemeViewModel(this._prefs, {ThemeMode initialTheme = ThemeMode.system})
      : _themeMode = initialTheme {
    _loadTheme();
  }

  void _loadTheme() {
    if (_prefs == null) return;
    final themeIndex = _prefs!.getInt(_themeKey);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    if (_prefs != null) {
      await _prefs!.setInt(_themeKey, mode.index);
    }
  }
}