import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/parental_config_provider.dart';
import 'services/audio_service.dart';
import 'screens/communication_board_screen.dart';
import 'screens/onboarding_screen.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ParentalConfigProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          final theme = themeProvider.currentTheme;
          
          return MaterialApp(
            title: 'My First Words',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: theme.primary,
                brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: const _RootDecider(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class _RootDecider extends StatefulWidget {
  const _RootDecider({super.key});

  @override
  State<_RootDecider> createState() => _RootDeciderState();
}

class _RootDeciderState extends State<_RootDecider> {
  bool? _onboardingComplete;
  bool _ttsReady = false;

  @override
  void initState() {
    super.initState();
    _loadFlag();
    _checkConnectivity();
  }

  Future<void> _loadFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('onboarding_complete') ?? false;
    
    // Carregar idioma salvo
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    await languageProvider.loadSavedLanguage();
    
    // Carregar tema salvo
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.loadSavedTheme();

    // Pré-inicializar TTS com o idioma atual (não bloquear UI)
    final currentLanguage = languageProvider.currentLanguageCode;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final audio = AudioService();
        await audio.initialize(currentLanguage);
        if (mounted) setState(() => _ttsReady = true);
      } catch (_) {
        if (mounted) setState(() => _ttsReady = false);
      }
    });
    
    if (!mounted) return;
    setState(() => _onboardingComplete = value);
  }

  Future<void> _checkConnectivity() async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 2));
    if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
      print('✅ Internet reachable');
    }
  } catch (_) {
    print('❌ No internet connectivity (lookup failed/timeout)');
  }
}

  @override
  Widget build(BuildContext context) {
    if (_onboardingComplete == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _onboardingComplete!
        ? const CommunicationBoardScreen()
        : const OnboardingScreen();
  }
}
