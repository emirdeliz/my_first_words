import 'package:flutter/material.dart';
import '../models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguageCode = 'pt-BR';
  static const String _languageKey = 'selected_language';

  String get currentLanguageCode => _currentLanguageCode;

  LanguageModel get currentLanguage =>
      LanguageModel.supportedLanguages[_currentLanguageCode] ??
      LanguageModel.supportedLanguages['pt-BR']!;

  // Carregar idioma salvo
  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      if (savedLanguage != null &&
          LanguageModel.supportedLanguages.containsKey(savedLanguage)) {
        _currentLanguageCode = savedLanguage;
        notifyListeners();
      }
    } catch (e) {
      // Em caso de erro, manter o idioma padrão
      _currentLanguageCode = 'pt-BR';
    }
  }

  void setLanguage(String languageCode,
      [Function(String)? onLanguageChanged]) async {
    if (LanguageModel.supportedLanguages.containsKey(languageCode)) {
      _currentLanguageCode = languageCode;

      // Salvar idioma selecionado
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageCode);
      } catch (e) {
        // Em caso de erro, continuar sem salvar
      }

      notifyListeners();

      // Notificar callback se fornecido
      if (onLanguageChanged != null) {
        onLanguageChanged(languageCode);
      }
    }
  }

  String getTranslation(String key) {
    return currentLanguage.getTranslation(key);
  }

  List<LanguageModel> get supportedLanguages {
    return LanguageModel.supportedLanguages.values.toList();
  }
}
