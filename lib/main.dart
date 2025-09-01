import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/parental_config_provider.dart';
import 'screens/communication_board_screen.dart';

void main() {
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
            home: const CommunicationBoardScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
