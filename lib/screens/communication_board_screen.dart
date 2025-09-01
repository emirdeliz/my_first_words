import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/communication_item.dart';
import '../models/parental_config_model.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/parental_config_provider.dart';
import '../services/audio_service.dart';
import '../widgets/communication_item_card.dart';
import 'settings_screen.dart';
import 'tts_test_screen.dart';

class CommunicationBoardScreen extends StatefulWidget {
  const CommunicationBoardScreen({super.key});

  @override
  State<CommunicationBoardScreen> createState() => _CommunicationBoardScreenState();
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
      await _audioService.initialize();
    } catch (e) {
      print('❌ Error initializing audio service: $e');
    }
  }

  void _handleItemTap(AudioItem item) async {
    try {
      await _audioService.speak(item.text);
    } catch (e) {
      print('❌ Error speaking text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LanguageProvider, ParentalConfigProvider>(
      builder: (context, themeProvider, languageProvider, parentalProvider, child) {
        final theme = themeProvider.currentTheme;
        final appTitle = languageProvider.getTranslation('appTitle');
        final enabledItems = parentalProvider.getEnabledItems();
        final statusBarHeight = MediaQuery.of(context).padding.top;

        // Configurar status bar com ícones brancos
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light, // Ícones brancos
            statusBarBrightness: Brightness.dark, // Para iOS
          ),
        );

        return Scaffold(
          backgroundColor: theme.background,
          body: SafeArea(top: false,
            child: Column(
              children: [
                // Header com cor sólida (tons pastéis preferidos)
                Container(
                  color: theme.primary.withValues(alpha: 0.9),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 16 + statusBarHeight, 20, 16),
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
                              MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85, // Ajustado para dar mais espaço vertical
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
                            Icon(
                              Icons.volume_off,
                              size: 64,
                              color: theme.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum áudio configurado',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: theme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Vá para as configurações - Configuração Parental para ativar alguns áudios.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: theme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                                );
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text('Ir para Configurações'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
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
