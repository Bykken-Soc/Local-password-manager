import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Manages global theme state and persists the user preference to disk
class ThemeProvider extends ChangeNotifier {
  bool _isLightTheme = false; // Default: dark mode

  bool get isLightTheme => _isLightTheme;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Reads the saved theme preference from local storage on startup
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isLightTheme = prefs.getBool('is_light_theme') ?? false;
    notifyListeners();
  }

  // Toggles the theme, persists the choice, and updates listeners
  Future<void> toggleTheme() async {
    _isLightTheme = !_isLightTheme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_light_theme', _isLightTheme);
  }
}