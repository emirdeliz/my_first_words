import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  AudioService._internal() {
    _setupTTSCallbacks();
  }

  void _setupTTSCallbacks() {
    _flutterTts.setStartHandler(() {
      print('🎯 TTS started speaking');
    });

    _flutterTts.setCompletionHandler(() {
      print('✅ TTS completed speaking');
    });

    _flutterTts.setErrorHandler((msg) {
      print('❌ TTS error: $msg');
    });

    _flutterTts.setCancelHandler(() {
      print('⏹️ TTS cancelled');
    });
  }

  Future<void> initialize([String? languageCode]) async {
    if (_isInitialized) return;

    try {
      final language = languageCode ?? 'pt-BR';
      
      // Web TTS availability depends on browser; offline generally not guaranteed
      if (kIsWeb) {
        await _flutterTts.setLanguage(language);
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.setVolume(1.0);
        await _flutterTts.setPitch(1.0);
        _isInitialized = true;
        print('✅ AudioService initialized for Web with language: $language');
        return;
      }

      print('🔄 Initializing TTS for language: $language');
      
      // Verificar se o TTS está disponível no dispositivo
      try {
        final ttsStatus = await _flutterTts.isLanguageAvailable('en');
        print('🔍 TTS Engine Status: $ttsStatus');
      } catch (e) {
        print('⚠️ TTS Engine check failed: $e');
      }
      
      // Verificar se o idioma está disponível
      final isAvailable = await _flutterTts.isLanguageAvailable(language);
      print('🌍 Language available: $isAvailable');
      
      if (!isAvailable) {
        print('⚠️ Language $language not available, trying fallback...');
        // Tentar idioma base (pt, en, es, de)
        final baseLanguage = language.split('-')[0];
        final fallbackAvailable = await _flutterTts.isLanguageAvailable(baseLanguage);
        if (fallbackAvailable) {
          print('✅ Using fallback language: $baseLanguage');
          await _flutterTts.setLanguage(baseLanguage);
        } else {
          print('⚠️ Fallback language also not available, using default');
          // Tentar inglês como último recurso
          try {
            await _flutterTts.setLanguage('en');
            print('✅ Using English as fallback');
          } catch (e) {
            print('❌ Even English fallback failed: $e');
          }
        }
      } else {
        await _flutterTts.setLanguage(language);
      }
      
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      // Verificar configurações aplicadas
      print('✅ TTS configured successfully');
      
      await _applyPreferredVoice(language);
      
      _isInitialized = true;
      print('✅ AudioService initialized successfully with language: $language');
    } catch (e) {
      print('❌ Error initializing AudioService: $e');
      print('❌ Error details: ${e.toString()}');
      _isInitialized = false;
    }
  }

  bool _isVoiceOfflineCapable(Map<String, dynamic> v) {
    final name = (v['name'] ?? '').toString().toLowerCase();
    final engine = (v['engine'] ?? '').toString().toLowerCase();
    final requiresNetwork = (
      v['requiresNetwork'] ?? v['isNetworkConnectionRequired'] ?? v['networkConnectionRequired'] ?? false
    );
    final requiresNetworkBool = requiresNetwork is bool
        ? requiresNetwork
        : requiresNetwork.toString().toLowerCase() == 'true';
    // Heuristics to avoid cloud/online-only voices
    final looksCloud = name.contains('cloud') || name.contains('online') || name.contains('wavenet');
    return !requiresNetworkBool && !looksCloud && !engine.contains('cloud');
  }

  Future<void> _applyPreferredVoice([String? specificProfile, String? languageCode]) async {
    try {
      String voiceProfile = specificProfile ?? 'female';
      final language = languageCode ?? 'pt-BR';
      
      if (specificProfile == null) {
        final prefs = await SharedPreferences.getInstance();
        final profile = prefs.getString('parental_config') ?? '';
        // We only need the voiceProfile string; read it safely
        if (profile.isNotEmpty) {
          // naive extraction to avoid json decode dependence here
          // Prefer passing explicitly from provider in real apps
          if (profile.contains('"voiceProfile":"male"')) voiceProfile = 'male';
          if (profile.contains('"voiceProfile":"child"')) voiceProfile = 'child';
        }
      }

      final voices = await getAvailableVoices();

      Map<String, dynamic>? selected;
      bool matchesLanguage(Map<String, dynamic> v, String targetLanguage) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final locale = (v['locale'] ?? '').toString().toLowerCase();
        
        switch (targetLanguage.toLowerCase()) {
          case 'pt-br':
            final isPtBr = locale.contains('pt-br') || locale.contains('pt_br') || name.contains('pt-br') || name.contains('pt_br') || name.contains('brazil');
            final isPtPt = locale.contains('pt-pt') || locale.contains('pt_pt') || name.contains('pt-pt') || name.contains('pt_pt') || name.contains('portugal');
            return isPtBr && !isPtPt;
          case 'en':
          case 'en-us':
            return locale.contains('en') || name.contains('en') || name.contains('english') || name.contains('us');
          case 'es':
          case 'es-es':
            return locale.contains('es') || name.contains('es') || name.contains('spanish') || name.contains('español');
          case 'de':
          case 'de-de':
            return locale.contains('de') || name.contains('de') || name.contains('german') || name.contains('deutsch');
          default:
            return locale.contains(targetLanguage.toLowerCase()) || name.contains(targetLanguage.toLowerCase());
        }
      }

      bool matchesGender(Map<String, dynamic> v, String gender) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final quality = (v['quality'] ?? '').toString().toLowerCase();
        final genderField = (v['gender'] ?? '').toString().toLowerCase();
        if (gender == 'male') {
          return genderField.contains('male') || name.contains('male') || name.contains('masc') || name.contains('m1');
        } else if (gender == 'female') {
          return genderField.contains('female') || name.contains('female') || name.contains('fem') || name.contains('f1');
        } else if (gender == 'child') {
          return name.contains('child') || name.contains('kid') || name.contains('crianca') || name.contains('jovem') || quality.contains('enhanced');
        }
        return false;
      }

      // Filter voices for the target language
      final List<Map<String, dynamic>> languageVoices = [];
      for (final voice in voices) {
        if (matchesLanguage(voice, language)) {
          languageVoices.add(voice);
        }
      }

      if (languageVoices.isEmpty) {
        print('⚠️ No voices found for language $language, using default');
        return;
      }

      // Prefer offline-capable voices
      final offlineCandidates = <Map<String, dynamic>>[];
      for (final v in languageVoices) {
        if (_isVoiceOfflineCapable(v)) offlineCandidates.add(v);
      }
      final source = offlineCandidates.isNotEmpty ? offlineCandidates : languageVoices;

      // Try to find a voice that matches the profile
      Map<String, dynamic>? selectedVoice;
      
      if (voiceProfile == 'male') {
        // Look for male characteristics
        for (final voice in source) {
          final name = (voice['name'] ?? '').toString().toLowerCase();
          if (name.contains('masc') || name.contains('m1') || name.contains('male') || name.contains('homem')) {
            selectedVoice = voice;
            break;
          }
        }
        selectedVoice ??= source.first;
      } else if (voiceProfile == 'female') {
        // Look for female characteristics
        for (final voice in source) {
          final name = (voice['name'] ?? '').toString().toLowerCase();
          if (name.contains('fem') || name.contains('f1') || name.contains('female') || name.contains('mulher')) {
            selectedVoice = voice;
            break;
          }
        }
        selectedVoice ??= source.first;
      } else if (voiceProfile == 'child') {
        // Look for child characteristics
        for (final voice in source) {
          final name = (voice['name'] ?? '').toString().toLowerCase();
          if (name.contains('crianca') || name.contains('jovem') || name.contains('child') || name.contains('kid')) {
            selectedVoice = voice;
            break;
          }
        }
        selectedVoice ??= source.first;
      }

      if (selectedVoice != null && selectedVoice.isNotEmpty) {
        // Priorizar nomes contendo natural/neural ao aplicar
        final candidates = <Map<String, dynamic>>[];
        for (final v in source) {
          final name = (v['name'] ?? '').toString().toLowerCase();
          if (name.contains('neural') || name.contains('natural')) {
            candidates.add(v);
          }
        }
        final chosen = candidates.isNotEmpty ? candidates.first : selectedVoice;
        final voiceName = chosen['name'];
        final locale = chosen['locale'];
        if (voiceName != null) {
          await _flutterTts.setVoice({'name': voiceName, 'locale': locale});
          print('🗣️ Using $voiceProfile voice: $voiceName (${locale ?? 'unknown'})');
        }
      }
    } catch (e) {
      print('❌ Error applying preferred voice: $e');
    }
  }

  Future<void> speakWithVoice(String text, String voiceProfile) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _applyPreferredVoice(voiceProfile);
      await _flutterTts.speak(text);
      print('🔊 Speaking with $voiceProfile voice: $text');
    } catch (e) {
      print('❌ Error speaking with voice: $e');
    }
  }

  Future<void> setSpecificVoice(String voiceName, String locale) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterTts.setVoice({'name': voiceName, 'locale': locale});
      print('🗣️ Set specific voice: $voiceName ($locale)');
    } catch (e) {
      print('❌ Error setting specific voice: $e');
    }
  }

  Future<void> speak(String text, [String? languageCode]) async {
    try {
      print('🔄 Speak called with text: "$text" and language: $languageCode');
      
      if (!_isInitialized) {
        print('🔄 TTS not initialized, initializing now...');
        await initialize(languageCode);
      } else if (languageCode != null) {
        // If already initialized but language changed, update it
        print('🔄 Language changed, updating TTS...');
        await setLanguage(languageCode);
      }

      // Verificar se o TTS está funcionando
      bool isAvailable = false;
      try {
        isAvailable = await _flutterTts.isLanguageAvailable(languageCode ?? 'pt-BR');
        print('🌍 Language available: $isAvailable');
      } catch (e) {
        print('⚠️ Could not check language availability: $e');
      }
      
      // Verificar se o TTS está ativo
      try {
        // isSpeaking não existe no flutter_tts, vamos pular essa verificação
        print('🔊 TTS speaking status check skipped (not available)');
      } catch (e) {
        print('⚠️ Could not check speaking status: $e');
      }
      
      // Tentar falar
      print('🎯 Attempting to speak: $text');
      await _flutterTts.speak(text);
      print('✅ Speak command sent successfully');
      
    } catch (e) {
      print('❌ Error speaking: $e');
      print('❌ Error details: ${e.toString()}');
      print('❌ Error type: ${e.runtimeType}');
      
      // Tentar reinicializar em caso de erro
      _isInitialized = false;
      try {
        print('🔄 Attempting to reinitialize TTS...');
        await initialize(languageCode);
        await _flutterTts.speak(text);
        print('✅ Speaking after reinitialization: $text');
      } catch (e2) {
        print('❌ Error after reinitialization: $e2');
        print('❌ Final error details: ${e2.toString()}');
      }
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      print('⏹️ Speech stopped');
    } catch (e) {
      print('❌ Error stopping speech: $e');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      await _flutterTts.setLanguage(languageCode);
      print('🌍 Language set to: $languageCode');
    } catch (e) {
      print('❌ Error setting language: $e');
    }
  }

  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
      print('🎵 Speech rate set to: $rate');
    } catch (e) {
      print('❌ Error setting speech rate: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume);
      print('🔊 Volume set to: $volume');
    } catch (e) {
      print('❌ Error setting volume: $e');
    }
  }

  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch);
      print('🎼 Pitch set to: $pitch');
    } catch (e) {
      print('❌ Error setting pitch: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableVoices() async {
    try {
      print('🔄 Getting available voices from TTS...');
      final voices = await _flutterTts.getVoices;
      print('🎤 Raw voices response: $voices');
      
      final List<Map<String, dynamic>> convertedVoices = [];
      
      if (voices is List) {
        print('✅ Voices is a List with ${voices.length} items');
        for (final voice in voices) {
          if (voice is Map) {
            convertedVoices.add(Map<String, dynamic>.from(voice));
          } else {
            print('⚠️ Voice item is not a Map: ${voice.runtimeType} - $voice');
          }
        }
      } else {
        print('⚠️ Voices is not a List: ${voices.runtimeType}');
      }
      
      print('🎤 Converted ${convertedVoices.length} voices');
      if (convertedVoices.isNotEmpty) {
        print('🎤 Sample voice: ${convertedVoices.first}');
      }
      
      return convertedVoices;
    } catch (e) {
      print('❌ Error getting voices: $e');
      print('❌ Error details: ${e.toString()}');
      return [];
    }
  }

  Future<List<String>> getAvailableLanguages() async {
    try {
      print('🔄 Getting available languages from TTS...');
      final languages = await _flutterTts.getLanguages;
      print('🌍 Raw languages response: $languages');
      
      final List<String> convertedLanguages = [];
      
      if (languages is List) {
        print('✅ Languages is a List with ${languages.length} items');
        for (final language in languages) {
          if (language is String) {
            convertedLanguages.add(language);
          } else {
            print('⚠️ Language item is not a String: ${language.runtimeType} - $language');
          }
        }
      } else {
        print('⚠️ Languages is not a List: ${languages.runtimeType}');
      }
      
      print('🌍 Converted ${convertedLanguages.length} languages');
      if (convertedLanguages.isNotEmpty) {
        print('🌍 Sample language: ${convertedLanguages.first}');
      }
      
      return convertedLanguages;
    } catch (e) {
      print('❌ Error getting languages: $e');
      print('❌ Error details: ${e.toString()}');
      return [];
    }
  }

  Future<bool> isTTSAvailable() async {
    try {
      print('🔍 Starting comprehensive TTS availability check...');
      
      // Verificar se o TTS está funcionando
      bool hasLanguage = false;
      try {
        hasLanguage = await _flutterTts.isLanguageAvailable('en');
        print('🔍 TTS Language Check: $hasLanguage');
      } catch (e) {
        print('❌ TTS Language Check Failed: $e');
      }
      
      // Verificar se o TTS está ativo
      print('🔍 TTS Speaking Status check skipped (not available)');
      
      // Verificar se o TTS pode ser configurado
      bool canConfigure = false;
      try {
        await _flutterTts.setSpeechRate(0.5);
        canConfigure = true;
        print('🔍 TTS Configuration Check: $canConfigure');
      } catch (e) {
        print('❌ TTS Configuration Check Failed: $e');
      }
      
      final overallStatus = hasLanguage && canConfigure;
      print('🔍 Overall TTS Status: $overallStatus');
      
      return overallStatus;
    } catch (e) {
      print('❌ TTS Availability Check Failed: $e');
      return false;
    }
  }

  // Métodos públicos para testes diretos
  Future<void> speakDirect(String text) async {
    try {
      await _flutterTts.speak(text);
      print('✅ Direct speak: $text');
    } catch (e) {
      print('❌ Direct speak failed: $e');
    }
  }

  Future<void> setLanguageDirect(String language) async {
    try {
      await _flutterTts.setLanguage(language);
      print('✅ Direct language set: $language');
    } catch (e) {
      print('❌ Direct language set failed: $e');
    }
  }

  Future<bool> checkLanguageAvailability(String language) async {
    try {
      final available = await _flutterTts.isLanguageAvailable(language);
      print('✅ Language availability check: $language = $available');
      return available;
    } catch (e) {
      print('❌ Language availability check failed: $e');
      return false;
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}


