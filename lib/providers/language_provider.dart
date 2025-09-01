import 'package:flutter/material.dart';
import '../models/language_model.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguageCode = 'pt-BR';
  
  String get currentLanguageCode => _currentLanguageCode;
  
  LanguageModel get currentLanguage => 
      LanguageModel.supportedLanguages[_currentLanguageCode] ?? 
      LanguageModel.supportedLanguages['pt-BR']!;
  
  void setLanguage(String languageCode) {
    if (LanguageModel.supportedLanguages.containsKey(languageCode)) {
      _currentLanguageCode = languageCode;
      notifyListeners();
    }
  }
  
  String getTranslation(String key) {
    return currentLanguage.getTranslation(key);
  }
  
  List<LanguageModel> get supportedLanguages {
    return LanguageModel.supportedLanguages.values.toList();
  }
}
