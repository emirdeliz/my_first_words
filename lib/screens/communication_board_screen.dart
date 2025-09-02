import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/communication_item.dart';
import '../models/parental_config_model.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/parental_config_provider.dart';
import '../services/audio_service.dart';
import '../design_system/design_system.dart';
import '../widgets/communication_item_card.dart';
import 'settings_screen.dart';

class CommunicationBoardScreen extends StatefulWidget {
  const CommunicationBoardScreen({super.key});

  @override
  State<CommunicationBoardScreen> createState() =>
      _CommunicationBoardScreenState();
}

class _CommunicationBoardScreenState extends State<CommunicationBoardScreen> {
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _initializeAudioService();
  }

  Future<void> _initializeAudioService() async {
    try {
      final languageCode = context.read<LanguageProvider>().currentLanguageCode;
      await _audioService.initialize(languageCode);
    } catch (e) {
      print('❌ Error initializing audio service: $e');
    }
  }

  void _handleItemTap(AudioItem item) async {
    try {
      final languageCode = context.read<LanguageProvider>().currentLanguageCode;
      await _audioService.speak(item.text, languageCode);
    } catch (e) {
      print('❌ Error speaking text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LanguageProvider, ParentalConfigProvider>(
      builder:
          (context, themeProvider, languageProvider, parentalProvider, child) {
        final theme = themeProvider.currentTheme;
        final appTitle = languageProvider.getTranslation('appTitle');
        final enabledItems = parentalProvider.getEnabledItems();
        final statusBarHeight = MediaQuery.of(context).padding.top;
        final translation = languageProvider.getTranslation;

        // Configurar status bar com ícones brancos
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light, // Ícones brancos
            statusBarBrightness: Brightness.dark, // Para iOS
          ),
        );

        return Scaffold(
          backgroundColor: theme.background,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // Header com cor sólida (tons pastéis preferidos)
                Container(
                  color: theme.primary.withValues(alpha: 0.9),
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(20, 16 + statusBarHeight, 20, 16),
                    child: Row(
                      children: [
                        // Microphone icon removed as requested
                        Expanded(
                          child: Text(
                            appTitle,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.textInverse,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsScreen()),
                            );
                          },
                          icon: Icon(Icons.settings, color: theme.textInverse),
                        ),
                      ],
                    ),
                  ),
                ),

                // Communication Items Grid
                if (enabledItems.isNotEmpty)
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio:
                            0.85, // Ajustado para dar mais espaço vertical
                      ),
                      itemCount: enabledItems.length,
                      itemBuilder: (context, index) {
                        final item = enabledItems[index];
                        return CommunicationItemCard(
                          item: CommunicationItem(
                            id: item.id,
                            categoryId: item.categoryId,
                            textKey: item.textKey,
                            text: item.text,
                            icon: item.icon,
                            type: item.type,
                            isEnabled: item.isEnabled,
                          ),
                          theme: theme,
                          onTap: () => _handleItemTap(item),
                          languageProvider: languageProvider,
                        );
                      },
                    ),
                  )
                else
                  // Mensagem quando não há áudios configurados
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DSIcon(
                              Icons.volume_off,
                              icon8: true,
                              color: theme.textSecondary,
                            ),
                            const DSVerticalSpacing.lg(),
                            DSTitle(
                              translation('parentalConfig.noAudioConfigured'),
                              textAlign: TextAlign.center,
                              color: theme.textSecondary,
                            ),
                            const DSVerticalSpacing.sm(),
                            DSBody(
                              translation('parentalConfig.goToSettings'),
                              textAlign: TextAlign.center,
                              color: theme.textSecondary,
                            ),
                            const DSVerticalSpacing.xl2(),
                            DSButton(
                              text: translation('ui.goToSettingsCta'),
                              icon: Icons.settings,
                              primary: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
