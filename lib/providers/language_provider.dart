import 'package:flutter/material.dart';
import '../models/language_model.dart';
import 'package:provider/provider.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguageCode = 'pt-BR';
  
  String get currentLanguageCode => _currentLanguageCode;
  
  LanguageModel get currentLanguage => 
      LanguageModel.supportedLanguages[_currentLanguageCode] ?? 
      LanguageModel.supportedLanguages['pt-BR']!;
  
  void setLanguage(String languageCode, [Function(String)? onLanguageChanged]) {
    if (LanguageModel.supportedLanguages.containsKey(languageCode)) {
      _currentLanguageCode = languageCode;
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
