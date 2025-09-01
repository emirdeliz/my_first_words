class LanguageModel {
  final String code;
  final String name;
  final String nativeName;
  final Map<String, dynamic> translations;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.translations,
  });

  static const Map<String, LanguageModel> supportedLanguages = {
    'pt-BR': LanguageModel(
      code: 'pt-BR',
      name: 'Portuguese (Brazil)',
      nativeName: 'Português (Brasil)',
      translations: {
        'appTitle': 'My first words',
        'basicNeeds': {
          'hunger': 'Fome',
          'thirst': 'Sede',
          'bathroom': 'Banheiro',
          'sleep': 'Sono',
          'pain': 'Dor',
          'help': 'Ajuda',
        },
        'emotions': {
          'happy': 'Feliz',
          'sad': 'Triste',
          'angry': 'Bravo',
          'scared': 'Com medo',
          'excited': 'Animado',
          'tired': 'Cansado',
        },
        'activities': {
          'play': 'Brincar',
          'eat': 'Comer',
          'drink': 'Beber',
          'sleep': 'Dormir',
          'read': 'Ler',
          'draw': 'Desenhar',
        },
        'social': {
          'hello': 'Olá',
          'goodbye': 'Tchau',
          'please': 'Por favor',
          'thankYou': 'Obrigado',
          'sorry': 'Desculpe',
          'yes': 'Sim',
          'no': 'Não',
        },
        'parentalConfig': {
          'noAudioConfigured': 'Nenhum áudio configurado',
          'goToSettings': 'Vá para as configurações',
        },
      },
    ),
    'en': LanguageModel(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      translations: {
        'appTitle': 'My First Words',
        'basicNeeds': {
          'hunger': 'Hunger',
          'thirst': 'Thirst',
          'bathroom': 'Bathroom',
          'sleep': 'Sleep',
          'pain': 'Pain',
          'help': 'Help',
        },
        'emotions': {
          'happy': 'Happy',
          'sad': 'Sad',
          'angry': 'Angry',
          'scared': 'Scared',
          'excited': 'Excited',
          'tired': 'Tired',
        },
        'activities': {
          'play': 'Play',
          'eat': 'Eat',
          'drink': 'Drink',
          'sleep': 'Sleep',
          'read': 'Read',
          'draw': 'Draw',
        },
        'social': {
          'hello': 'Hello',
          'goodbye': 'Goodbye',
          'please': 'Please',
          'thankYou': 'Thank you',
          'sorry': 'Sorry',
          'yes': 'Yes',
          'no': 'No',
        },
        'parentalConfig': {
          'noAudioConfigured': 'No audio configured',
          'goToSettings': 'Go to settings',
        },
      },
    ),
    'es': LanguageModel(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      translations: {
        'appTitle': 'My first words',
        'basicNeeds': {
          'hunger': 'Hambre',
          'thirst': 'Sed',
          'bathroom': 'Baño',
          'sleep': 'Sueño',
          'pain': 'Dolor',
          'help': 'Ayuda',
        },
        'emotions': {
          'happy': 'Feliz',
          'sad': 'Triste',
          'angry': 'Enojado',
          'scared': 'Asustado',
          'excited': 'Emocionado',
          'tired': 'Cansado',
        },
        'activities': {
          'play': 'Jugar',
          'eat': 'Comer',
          'drink': 'Beber',
          'sleep': 'Dormir',
          'read': 'Leer',
          'draw': 'Dibujar',
        },
        'social': {
          'hello': 'Hola',
          'goodbye': 'Adiós',
          'please': 'Por favor',
          'thankYou': 'Gracias',
          'sorry': 'Lo siento',
          'yes': 'Sí',
          'no': 'No',
        },
        'parentalConfig': {
          'noAudioConfigured': 'No hay audio configurado',
          'goToSettings': 'Ve a la configuración',
        },
      },
    ),
    'de': LanguageModel(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      translations: {
        'appTitle': 'My first words',
        'basicNeeds': {
          'hunger': 'Hunger',
          'thirst': 'Durst',
          'bathroom': 'Badezimmer',
          'sleep': 'Schlaf',
          'pain': 'Schmerz',
          'help': 'Hilfe',
        },
        'emotions': {
          'happy': 'Glücklich',
          'sad': 'Traurig',
          'angry': 'Wütend',
          'scared': 'Angst',
          'excited': 'Aufgeregt',
          'tired': 'Müde',
        },
        'activities': {
          'play': 'Spielen',
          'eat': 'Essen',
          'drink': 'Trinken',
          'sleep': 'Schlafen',
          'read': 'Lesen',
          'draw': 'Zeichnen',
        },
        'social': {
          'hello': 'Hallo',
          'goodbye': 'Auf Wiedersehen',
          'please': 'Bitte',
          'thankYou': 'Danke',
          'sorry': 'Entschuldigung',
          'yes': 'Ja',
          'no': 'Nein',
        },
        'parentalConfig': {
          'noAudioConfigured': 'Kein Audio konfiguriert',
          'goToSettings': 'Gehen Sie zu den Einstellungen',
        },
      },
    ),
  };

  String getTranslation(String key) {
    final keys = key.split('.');
    dynamic current = translations;
    
    for (final k in keys) {
      if (current is Map && current.containsKey(k)) {
        current = current[k];
      } else {
        return key; // Fallback to key if translation not found
      }
    }
    
    return current?.toString() ?? key;
  }
}
