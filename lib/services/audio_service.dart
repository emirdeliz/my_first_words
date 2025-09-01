import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _flutterTts.setLanguage('pt-BR');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      _isInitialized = true;
      print('✅ AudioService initialized successfully');
    } catch (e) {
      print('❌ Error initializing AudioService: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterTts.speak(text);
      print('🔊 Speaking: $text');
    } catch (e) {
      print('❌ Error speaking: $e');
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
      final voices = await _flutterTts.getVoices;
      return List<Map<String, dynamic>>.from(voices);
    } catch (e) {
      print('❌ Error getting voices: $e');
      return [];
    }
  }

  Future<List<String>> getAvailableLanguages() async {
    try {
      final languages = await _flutterTts.getLanguages;
      return List<String>.from(languages);
    } catch (e) {
      print('❌ Error getting languages: $e');
      return [];
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}
