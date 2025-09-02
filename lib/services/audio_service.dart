import 'package:flutter_tts/flutter_tts.dart';
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
      print('🔄 Initializing TTS for language: $language');

      // Try to select a stable engine on Android (non-blocking, best-effort)
      () async {
        try {
          final engines = await _flutterTts.getEngines
              .timeout(const Duration(milliseconds: 1200), onTimeout: () => []);
          if (engines is List && engines.isNotEmpty) {
            final engineNames = engines.map((e) => e.toString()).toList();
            final googleTts = engineNames.firstWhere(
              (e) => e.contains('com.google.android.tts'),
              orElse: () => '',
            );
            if (googleTts.isNotEmpty) {
              try {
                await _flutterTts
                    .setEngine(googleTts)
                    .timeout(const Duration(milliseconds: 800));
                print('✅ TTS engine selected: $googleTts');
              } catch (_) {}
            }
          }
        } catch (_) {}
      }();

      // 1) Base config quickly, without blocking on lookups
      try {
        await _flutterTts
            .setLanguage(language)
            .timeout(const Duration(milliseconds: 1200));
      } catch (_) {
        // Silent fallback: continue without forcing language now
      }
      try {
        await _flutterTts
            .setSpeechRate(0.5)
            .timeout(const Duration(milliseconds: 800));
      } catch (_) {
        // Silent fallback
      }
      try {
        await _flutterTts
            .setVolume(1.0)
            .timeout(const Duration(milliseconds: 800));
      } catch (_) {
        // Silent fallback
      }
      try {
        await _flutterTts
            .setPitch(1.0)
            .timeout(const Duration(milliseconds: 800));
      } catch (_) {
        // Silent fallback
      }
      _isInitialized = true;
      print('✅ Base TTS configured');

      // 2) Fire-and-forget checks and voice selection with short timeouts
      // Avoid blocking UI if device is offline or engine is slow
      () async {
        try {
          // Wrap language availability in timeout (1.5s)
          bool isAvailable = true;
          try {
            isAvailable = await _flutterTts
                .isLanguageAvailable(language)
                .timeout(const Duration(minutes: 1));
            print('🌍 Language available (timed): $isAvailable');
          } catch (e) {
            print('⚠️ Language availability check timed out or failed: $e');
          }

          if (!isAvailable) {
            final baseLanguage = language.split('-')[0];
            try {
              final fallbackAvailable = await _flutterTts
                  .isLanguageAvailable(baseLanguage)
                  .timeout(const Duration(milliseconds: 1500));
              if (fallbackAvailable) {
                await _flutterTts.setLanguage(baseLanguage);
                print('✅ Using fallback language: $baseLanguage');
              } else {
                try {
                  await _flutterTts.setLanguage('en');
                  print('✅ Using English as last-resort fallback');
                } catch (_) {}
              }
            } catch (e) {
              print('⚠️ Fallback language check failed: $e');
            }
          }

          // Apply preferred voice with timeout (2s)
          try {
            await _applyPreferredVoice(language)
                .timeout(const Duration(seconds: 2));
          } catch (_) {}
        } catch (e) {
          print('⚠️ Post-init tasks failed: $e');
        }
      }();

      print(
          '✅ AudioService initialized successfully (non-blocking) with language: $language');
    } catch (e) {
      print('❌ Error initializing AudioService: $e');
      print('❌ Error details: ${e.toString()}');
      _isInitialized = false;
    }
  }

  bool _isVoiceOfflineCapable(Map<String, dynamic> v) {
    final name = (v['name'] ?? '').toString().toLowerCase();
    final engine = (v['engine'] ?? '').toString().toLowerCase();
    final requiresNetwork = (v['requiresNetwork'] ??
        v['isNetworkConnectionRequired'] ??
        v['networkConnectionRequired'] ??
        false);
    final requiresNetworkBool = requiresNetwork is bool
        ? requiresNetwork
        : requiresNetwork.toString().toLowerCase() == 'true';
    // Heuristics to avoid cloud/online-only voices
    final looksCloud = name.contains('cloud') ||
        name.contains('online') ||
        name.contains('wavenet');
    return !requiresNetworkBool && !looksCloud && !engine.contains('cloud');
  }

  Future<void> _applyPreferredVoice(
      [String? specificProfile, String? languageCode]) async {
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
          if (profile.contains('"voiceProfile":"child"'))
            voiceProfile = 'child';
        }
      }

      final voices = await getAvailableVoices();

      Map<String, dynamic>? selected;
      bool matchesLanguage(Map<String, dynamic> v, String targetLanguage) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final locale = (v['locale'] ?? '').toString().toLowerCase();

        switch (targetLanguage.toLowerCase()) {
          case 'pt-br':
            final isPtBr = locale.contains('pt-br') ||
                locale.contains('pt_br') ||
                name.contains('pt-br') ||
                name.contains('pt_br') ||
                name.contains('brazil');
            final isPtPt = locale.contains('pt-pt') ||
                locale.contains('pt_pt') ||
                name.contains('pt-pt') ||
                name.contains('pt_pt') ||
                name.contains('portugal');
            return isPtBr && !isPtPt;
          case 'en':
          case 'en-us':
            return locale.contains('en') ||
                name.contains('en') ||
                name.contains('english') ||
                name.contains('us');
          case 'es':
          case 'es-es':
            return locale.contains('es') ||
                name.contains('es') ||
                name.contains('spanish') ||
                name.contains('español');
          case 'de':
          case 'de-de':
            return locale.contains('de') ||
                name.contains('de') ||
                name.contains('german') ||
                name.contains('deutsch');
          default:
            return locale.contains(targetLanguage.toLowerCase()) ||
                name.contains(targetLanguage.toLowerCase());
        }
      }

      bool matchesGender(Map<String, dynamic> v, String gender) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final quality = (v['quality'] ?? '').toString().toLowerCase();
        final genderField = (v['gender'] ?? '').toString().toLowerCase();
        if (gender == 'male') {
          return genderField.contains('male') ||
              name.contains('male') ||
              name.contains('masc') ||
              name.contains('m1');
        } else if (gender == 'female') {
          return genderField.contains('female') ||
              name.contains('female') ||
              name.contains('fem') ||
              name.contains('f1');
        } else if (gender == 'child') {
          return name.contains('child') ||
              name.contains('kid') ||
              name.contains('crianca') ||
              name.contains('jovem') ||
              quality.contains('enhanced');
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
      final source =
          offlineCandidates.isNotEmpty ? offlineCandidates : languageVoices;

      // Try to find a voice that matches the profile
      Map<String, dynamic>? selectedVoice;

      if (voiceProfile == 'male') {
        // Look for male characteristics
        for (final voice in source) {
          final name = (voice['name'] ?? '').toString().toLowerCase();
          if (name.contains('masc') ||
              name.contains('m1') ||
              name.contains('male') ||
              name.contains('homem')) {
            selectedVoice = voice;
            break;
          }
        }
        selectedVoice ??= source.first;
      } else if (voiceProfile == 'female') {
        // Look for female characteristics
        for (final voice in source) {
          final name = (voice['name'] ?? '').toString().toLowerCase();
          if (name.contains('fem') ||
              name.contains('f1') ||
              name.contains('female') ||
              name.contains('mulher')) {
            selectedVoice = voice;
            break;
          }
        }
        selectedVoice ??= source.first;
      } else if (voiceProfile == 'child') {
        // Look for child characteristics
        for (final voice in source) {
          final name = (voice['name'] ?? '').toString().toLowerCase();
          if (name.contains('crianca') ||
              name.contains('jovem') ||
              name.contains('child') ||
              name.contains('kid')) {
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
          print(
              '🗣️ Using $voiceProfile voice: $voiceName (${locale ?? 'unknown'})');
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
        isAvailable =
            await _flutterTts.isLanguageAvailable(languageCode ?? 'pt-BR');
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

      Future<List<dynamic>> _fetchVoicesRaw() async {
        final resp = await _flutterTts.getVoices;

        print('🎤 Resp: $resp');
        return (resp is List) ? resp : [];
      }

      List<dynamic> raw = await _fetchVoicesRaw();
      print('🎤 Available voices: ${raw.length}');

      // If empty, try best-effort remediation: pick Google engine and re-apply language, then retry
      int attempts = 0;
      while (raw.isEmpty && attempts < 2) {
        attempts++;
        try {
          final engines = await _flutterTts.getEngines
              .timeout(const Duration(milliseconds: 1200), onTimeout: () => []);
          if (engines is List && engines.isNotEmpty) {
            final engineNames = engines.map((e) => e.toString()).toList();
            final googleTts = engineNames.firstWhere(
              (e) => e.contains('com.google.android.tts'),
              orElse: () => '',
            );
            if (googleTts.isNotEmpty) {
              try {
                await _flutterTts
                    .setEngine(googleTts)
                    .timeout(const Duration(milliseconds: 800));
              } catch (_) {}
            }
          }
        } catch (_) {}

        // Re-apply current language quickly (ignore errors)
        try {
          await _flutterTts
              .setLanguage('pt-BR')
              .timeout(const Duration(milliseconds: 800));
        } catch (_) {}

        await Future.delayed(const Duration(milliseconds: 250));
        raw = await _fetchVoicesRaw();
      }

      final List<Map<String, dynamic>> convertedVoices = [];
      for (final voice in raw) {
        if (voice is Map) {
          convertedVoices.add(Map<String, dynamic>.from(voice));
        }
      }

      print('🎤 Converted ${convertedVoices.length} voices');
      if (convertedVoices.isNotEmpty) {
        print('🎤 Sample voice: ${convertedVoices.first}');
      }
      return convertedVoices;
    } catch (e) {
      print('❌ Error getting voices: $e');
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
            print(
                '⚠️ Language item is not a String: ${language.runtimeType} - $language');
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
