import 'package:flutter/material.dart';
import '../models/theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  AppTheme get currentTheme => _isDarkMode ? AppTheme.dark : AppTheme.light;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  // Definir tema específico
  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}
