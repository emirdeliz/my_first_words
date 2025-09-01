import 'package:flutter/material.dart';
import '../models/theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'is_dark_mode';
  
  bool get isDarkMode => _isDarkMode;
  
  AppTheme get currentTheme => _isDarkMode ? AppTheme.dark : AppTheme.light;
  
  // Carregar tema salvo
  Future<void> loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getBool(_themeKey);
      if (savedTheme != null) {
        _isDarkMode = savedTheme;
        notifyListeners();
      }
    } catch (e) {
      // Em caso de erro, manter o tema padrão (light)
      _isDarkMode = false;
    }
  }
  
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    
    // Salvar tema selecionado
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      // Em caso de erro, continuar sem salvar
    }
    
    notifyListeners();
  }
  
  // Definir tema específico
  void setTheme(bool isDark) async {
    _isDarkMode = isDark;
    
    // Salvar tema selecionado
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      // Em caso de erro, continuar sem salvar
    }
    
    notifyListeners();
  }
}
