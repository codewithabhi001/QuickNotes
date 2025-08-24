import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Load theme from shared preferences
  Future<void> setTheme(bool isDarkMode) async {
    _isDarkMode = isDarkMode;
    notifyListeners();
    
    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    await setTheme(!_isDarkMode);
  }
}
