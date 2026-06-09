import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Define whether the theme is dark or light
  bool _isDarkMode = false;
  // Getter to check if it is dark mode
  bool get isDarkMode => _isDarkMode;
  // Method to toggle between dark and light mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify all listeners about the change
  }
  // Method to get the current theme data
  ThemeData get currentTheme {
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
