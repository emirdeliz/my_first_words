import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/parental_config_model.dart';
import '../models/language_model.dart';

class ParentalConfigProvider with ChangeNotifier {
  ParentalConfig _config = ParentalConfig(
    enabledAudioItems: [],
    isParentMode: false,
    lastUpdated: DateTime.now(),
  );

  ParentalConfig get config => _config;

  String get voiceProfile => _config.voiceProfile;
  int get communicationLevel => _config.communicationLevel;

  void setVoiceProfile(String profile) {
    _config = _config.copyWith(
      voiceProfile: profile,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  void setCommunicationLevel(int level) {
    _config = _config.copyWith(
      communicationLevel: level,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Categorias disponíveis
  static const List<Map<String, dynamic>> categories = [
    {'id': 'basic', 'name': 'basicNeeds', 'icon': 'restaurant', 'color': 0xFF2563EB},
    {'id': 'emotions', 'name': 'emotions', 'icon': 'sentiment_satisfied', 'color': 0xFFDB2777},
    {'id': 'activities', 'name': 'activities', 'icon': 'sports_esports', 'color': 0xFF16A34A},
    {'id': 'social', 'name': 'social', 'icon': 'people', 'color': 0xFF9333EA},
  ];

  // Configuração padrão dos itens de áudio
  static const List<Map<String, dynamic>> defaultAudioItemsConfig = [
    // Necessidades básicas
    {'id': 'basic-hunger', 'categoryId': 'basic', 'textKey': 'hunger', 'icon': 'restaurant', 'type': 'basic'},
    {'id': 'basic-thirst', 'categoryId': 'basic', 'textKey': 'thirst', 'icon': 'local_drink', 'type': 'basic'},
    {'id': 'basic-bathroom', 'categoryId': 'basic', 'textKey': 'bathroom', 'icon': 'wc', 'type': 'basic'},
    {'id': 'basic-sleep', 'categoryId': 'basic', 'textKey': 'sleep', 'icon': 'bedtime', 'type': 'basic'},
    {'id': 'basic-pain', 'categoryId': 'basic', 'textKey': 'pain', 'icon': 'healing', 'type': 'basic'},
    {'id': 'basic-help', 'categoryId': 'basic', 'textKey': 'help', 'icon': 'help', 'type': 'basic'},
    
    // Emoções
    {'id': 'emotions-happy', 'categoryId': 'emotions', 'textKey': 'happy', 'icon': 'sentiment_satisfied', 'type': 'emotions'},
    {'id': 'emotions-sad', 'categoryId': 'emotions', 'textKey': 'sad', 'icon': 'sentiment_dissatisfied', 'type': 'emotions'},
    {'id': 'emotions-angry', 'categoryId': 'emotions', 'textKey': 'angry', 'icon': 'mood_bad', 'type': 'emotions'},
    {'id': 'emotions-scared', 'categoryId': 'emotions', 'textKey': 'scared', 'icon': 'sentiment_very_dissatisfied', 'type': 'emotions'},
    {'id': 'emotions-excited', 'categoryId': 'emotions', 'textKey': 'excited', 'icon': 'sentiment_very_satisfied', 'type': 'emotions'},
    {'id': 'emotions-tired', 'categoryId': 'emotions', 'textKey': 'tired', 'icon': 'sentiment_neutral', 'type': 'emotions'},
    
    // Atividades
    {'id': 'activities-play', 'categoryId': 'activities', 'textKey': 'play', 'icon': 'sports_esports', 'type': 'activities'},
    {'id': 'activities-eat', 'categoryId': 'activities', 'textKey': 'eat', 'icon': 'restaurant', 'type': 'activities'},
    {'id': 'activities-drink', 'categoryId': 'activities', 'textKey': 'drink', 'icon': 'local_drink', 'type': 'activities'},
    {'id': 'activities-sleep', 'categoryId': 'activities', 'textKey': 'sleep', 'icon': 'bedtime', 'type': 'activities'},
    {'id': 'activities-read', 'categoryId': 'activities', 'textKey': 'read', 'icon': 'book', 'type': 'activities'},
    {'id': 'activities-draw', 'categoryId': 'activities', 'textKey': 'draw', 'icon': 'brush', 'type': 'activities'},
    
    // Social
    {'id': 'social-hello', 'categoryId': 'social', 'textKey': 'hello', 'icon': 'waving_hand', 'type': 'social'},
    {'id': 'social-goodbye', 'categoryId': 'social', 'textKey': 'goodbye', 'icon': 'waving_hand', 'type': 'social'},
    {'id': 'social-please', 'categoryId': 'social', 'textKey': 'please', 'icon': 'favorite', 'type': 'social'},
    {'id': 'social-thankYou', 'categoryId': 'social', 'textKey': 'thankYou', 'icon': 'favorite', 'type': 'social'},
    {'id': 'social-sorry', 'categoryId': 'social', 'textKey': 'sorry', 'icon': 'favorite', 'type': 'social'},
    {'id': 'social-yes', 'categoryId': 'social', 'textKey': 'yes', 'icon': 'thumb_up', 'type': 'social'},
    {'id': 'social-no', 'categoryId': 'social', 'textKey': 'no', 'icon': 'thumb_down', 'type': 'social'},
  ];

  ParentalConfigProvider() {
    _loadConfig();
  }

  // Criar itens de áudio com texto traduzido
  List<AudioItem> _createTranslatedAudioItems(String languageCode) {
    final language = LanguageModel.supportedLanguages[languageCode];
    if (language == null) return [];

    return defaultAudioItemsConfig.map((item) {
      String translatedText = '';
      
      // Obter texto traduzido baseado na categoria e textKey
      if (item['categoryId'] == 'basic') {
        translatedText = language.translations['basicNeeds']?[item['textKey']] ?? item['textKey'];
      } else if (item['categoryId'] == 'emotions') {
        translatedText = language.translations['emotions']?[item['textKey']] ?? item['textKey'];
      } else if (item['categoryId'] == 'activities') {
        translatedText = language.translations['activities']?[item['textKey']] ?? item['textKey'];
      } else if (item['categoryId'] == 'social') {
        translatedText = language.translations['social']?[item['textKey']] ?? item['textKey'];
      }
      
      return AudioItem(
        id: item['id'],
        categoryId: item['categoryId'],
        textKey: item['textKey'],
        text: translatedText,
        icon: item['icon'],
        type: item['type'],
        isEnabled: true,
      );
    }).toList();
  }

  // Carregar configuração do armazenamento
  Future<void> _loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString('parental_config');
      
      if (configJson != null && configJson.isNotEmpty) {
        try {
          final configMap = json.decode(configJson);
          _config = ParentalConfig.fromJson(configMap);
        } catch (e) {
          // JSON inválido, usar configuração padrão
          _config = _createDefaultConfig();
        }
      } else {
        // Configuração padrão em português
        _config = _createDefaultConfig();
      }
      notifyListeners();
    } catch (e) {
      // Erro crítico, usar configuração padrão
      _config = _createDefaultConfig();
      notifyListeners();
    }
  }

  ParentalConfig _createDefaultConfig() {
    return ParentalConfig(
      enabledAudioItems: _createTranslatedAudioItems('pt-BR'),
      isParentMode: false,
      lastUpdated: DateTime.now(),
      voiceProfile: 'female',
      communicationLevel: 1,
    );
  }

  // Salvar configuração no armazenamento
  Future<void> _saveConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = json.encode(_config.toJson());
      await prefs.setString('parental_config', configJson);
    } catch (e) {
      print('❌ Erro ao salvar configuração parental: $e');
    }
  }

  // Alternar item de áudio
  void toggleAudioItem(String itemId) {
    _config = _config.copyWith(
      enabledAudioItems: _config.enabledAudioItems.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isEnabled: !item.isEnabled);
        }
        return item;
      }).toList(),
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Habilitar todos os itens em uma categoria
  void enableAllInCategory(String categoryId) {
    _config = _config.copyWith(
      enabledAudioItems: _config.enabledAudioItems.map((item) {
        if (item.categoryId == categoryId) {
          return item.copyWith(isEnabled: true);
        }
        return item;
      }).toList(),
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Desabilitar todos os itens em uma categoria
  void disableAllInCategory(String categoryId) {
    _config = _config.copyWith(
      enabledAudioItems: _config.enabledAudioItems.map((item) {
        if (item.categoryId == categoryId) {
          return item.copyWith(isEnabled: false);
        }
        return item;
      }).toList(),
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Habilitar todos os itens
  void enableAllItems() {
    _config = _config.copyWith(
      enabledAudioItems: _config.enabledAudioItems.map((item) => item.copyWith(isEnabled: true)).toList(),
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Desabilitar todos os itens
  void disableAllItems() {
    _config = _config.copyWith(
      enabledAudioItems: _config.enabledAudioItems.map((item) => item.copyWith(isEnabled: false)).toList(),
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Definir modo parental
  void setParentMode(bool isParent) {
    _config = _config.copyWith(
      isParentMode: isParent,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Obter todos os itens habilitados
  List<AudioItem> getEnabledItems() {
    return _config.enabledAudioItems.where((item) => item.isEnabled).toList();
  }

  // Obter itens habilitados por categoria
  List<AudioItem> getEnabledItemsByCategory(String categoryId) {
    return _config.enabledAudioItems.where((item) => item.categoryId == categoryId && item.isEnabled).toList();
  }

  // Verificar se um item específico está habilitado
  bool isItemEnabled(String itemId) {
    final item = _config.enabledAudioItems.firstWhere((item) => item.id == itemId, orElse: () => AudioItem(
      id: '',
      categoryId: '',
      textKey: '',
      text: '',
      icon: '',
      type: '',
      isEnabled: false,
    ));
    return item.isEnabled;
  }

  // Atualizar idioma
  void updateLanguage(String languageCode) {
    final newItems = _createTranslatedAudioItems(languageCode);
    
    // Manter o estado de habilitação dos itens existentes
    final updatedItems = newItems.map((newItem) {
      final existingItem = _config.enabledAudioItems.firstWhere(
        (item) => item.id == newItem.id,
        orElse: () => newItem,
      );
      return newItem.copyWith(isEnabled: existingItem.isEnabled);
    }).toList();

    _config = _config.copyWith(
      enabledAudioItems: updatedItems,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
    _saveConfig();
  }

  // Obter estatísticas de uma categoria
  String getCategoryStats(String categoryId) {
    final enabledItems = getEnabledItemsByCategory(categoryId);
    final totalItems = _config.enabledAudioItems.where((item) => item.categoryId == categoryId).length;
    return '${enabledItems.length}/$totalItems';
  }
}
