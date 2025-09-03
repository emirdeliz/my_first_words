import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
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

          // Ensure offline defaults (female/male) are stored for offline usage
          try {
            await _ensureOfflineDefaultVoices(language)
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

  Future<void> _ensureOfflineDefaultVoices(String language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final voices = await getAvailableVoices();

      bool matchesLanguage(Map<String, dynamic> v) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final locale = (v['locale'] ?? '').toString().toLowerCase();
        final target = language.toLowerCase();
        if (target == 'pt-br' || target == 'pt_br') {
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
        }
        return locale.contains(target) || name.contains(target);
      }

      Map<String, dynamic>? female;
      Map<String, dynamic>? male;
      for (final v in voices) {
        if (!matchesLanguage(v)) continue;
        if (!_isVoiceOfflineCapable(v)) continue;
        final name = (v['name'] ?? '').toString().toLowerCase();
        final genderField = (v['gender'] ?? '').toString().toLowerCase();
        if (female == null &&
            (genderField.contains('female') ||
                name.contains('female') ||
                name.contains('fem') ||
                name.contains('f1'))) {
          female = v;
        }
        if (male == null &&
            (genderField.contains('male') ||
                name.contains('male') ||
                name.contains('masc') ||
                name.contains('m1'))) {
          male = v;
        }
        if (female != null && male != null) break;
      }

      // Fallback to any offline voices if gender heuristic not found
      if (female == null) {
        for (final v in voices) {
          if (matchesLanguage(v) && _isVoiceOfflineCapable(v)) {
            female = v;
            break;
          }
        }
      }
      if (male == null) {
        for (final v in voices) {
          if (matchesLanguage(v) && _isVoiceOfflineCapable(v)) {
            male = v;
            break;
          }
        }
      }

      if (female != null) {
        await prefs.setString(
            'offline_voice_female_name', (female['name'] ?? '').toString());
        await prefs.setString(
            'offline_voice_female_locale', (female['locale'] ?? '').toString());
      }
      if (male != null) {
        await prefs.setString(
            'offline_voice_male_name', (male['name'] ?? '').toString());
        await prefs.setString(
            'offline_voice_male_locale', (male['locale'] ?? '').toString());
      }
    } catch (e) {
      print('⚠️ ensureOfflineDefaultVoices failed: $e');
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
          if (profile.contains('"voiceProfile":"child"')) {
            voiceProfile = 'child';
          }
        }
      }

      final voices = await getAvailableVoices();

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

      // Removed unused helper: matchesGender

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

      if (selectedVoice == null || selectedVoice.isEmpty) {
        // If profile requested, try to use offline default stored in prefs
        try {
          final prefs = await SharedPreferences.getInstance();
          if (voiceProfile == 'female') {
            final n = prefs.getString('offline_voice_female_name');
            final l = prefs.getString('offline_voice_female_locale');
            if (n != null && l != null) {
              selectedVoice = {'name': n, 'locale': l};
            }
          } else if (voiceProfile == 'male') {
            final n = prefs.getString('offline_voice_male_name');
            final l = prefs.getString('offline_voice_male_locale');
            if (n != null && l != null) {
              selectedVoice = {'name': n, 'locale': l};
            }
          }
        } catch (_) {}
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

      // Primeiro, tentar tocar MP3 se disponível
      final mp3Played = await _playMp3IfAvailable(text);
      if (mp3Played) {
        print('✅ MP3 played successfully for: $text');
        return;
      }

      // Fallback para TTS se MP3 não estiver disponível
      print('🔄 MP3 not found, falling back to TTS for: $text');

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

  Future<bool> _playMp3IfAvailable(String text) async {
    // Criar nome do arquivo baseado no texto
    final fileName = _textToFileName(text);
    final audioPath = 'assets/mp3/pt-br/$fileName.mp3';

    try {
      print('🎵 Attempting to play MP3: $audioPath');
      print('🎵 File name: $fileName');

      // Parar qualquer áudio que esteja tocando
      await _audioPlayer.stop();

      // Aguardar um pouco para garantir que o player está pronto
      await Future.delayed(const Duration(milliseconds: 100));

      // Tentar tocar o MP3
      await _audioPlayer.play(AssetSource('mp3/pt-br/$fileName.mp3'));
      print('✅ MP3 played successfully: $fileName');
      return true;
    } catch (e) {
      print('⚠️ MP3 not available for "$text": $e');
      print('⚠️ File name attempted: $fileName');
      return false;
    }
  }

  String _textToFileName(String text) {
    // Mapear textos em português para nomes de arquivos em inglês
    final Map<String, String> textToFileMap = {
      // Necessidades básicas
      'fome': 'food',
      'comida': 'food',
      'sede': 'drink',
      'banheiro': 'bathroom',
      'sono': 'sleep',
      'dor': 'pain',
      'ajuda': 'help',

      // Emoções
      'feliz': 'happy',
      'triste': 'sad',
      'bravo': 'brave',
      'com medo': 'scared',
      'animado': 'excited',
      'cansado': 'tired',

      // Atividades
      'brincar': 'play',
      'comer': 'eat',
      'beber': 'drink',
      'dormir': 'sleep',
      'ler': 'read',
      'desenhar': 'draw',

      // Social
      'olá': 'hello',
      'tchau': 'goodbye',
      'por favor': 'please',
      'obrigado': 'thanks',
      'desculpe': 'sorry',
      'sim': 'yes',
      'não': 'no',
    };

    // Tentar mapeamento direto primeiro
    final lowerText = text.toLowerCase().trim();
    if (textToFileMap.containsKey(lowerText)) {
      return textToFileMap[lowerText]!;
    }

    // Fallback: converter texto para nome de arquivo válido
    return lowerText
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '') // Remove caracteres especiais
        .replaceAll(RegExp(r'\s+'), '_') // Substitui espaços por underscore
        .replaceAll(RegExp(r'_+'), '_') // Remove underscores duplicados
        .replaceAll(RegExp(r'^_|_$'), ''); // Remove underscores do início/fim
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      await _audioPlayer.stop();
      print('⏹️ Speech and audio stopped');
    } catch (e) {
      print('❌ Error stopping speech/audio: $e');
    }
  }

  Future<void> openTtsSettings() async {
    try {
      // Note: openTtsSettings não está disponível em todas as versões do flutter_tts
      // Implementação alternativa pode ser necessária
      print(
          '⚙️ TTS settings method not available in current flutter_tts version');
    } catch (e) {
      print('❌ Error opening TTS settings: $e');
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

      Future<List<dynamic>> fetchVoicesRaw() async {
        final resp = await _flutterTts.getVoices;

        print('🎤 Resp: $resp');
        return (resp is List) ? resp : [];
      }

      List<dynamic> raw = await fetchVoicesRaw();
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
        raw = await fetchVoicesRaw();
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
    _audioPlayer.dispose();
  }
}
