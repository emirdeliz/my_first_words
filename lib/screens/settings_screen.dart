import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/parental_config_provider.dart';
import '../services/audio_service.dart';
import '../design_system/design_system.dart';
import 'parental_config_screen.dart';
import 'permissions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioService _audioService = AudioService();
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;

  List<String> _availableLanguages = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final languages = await _audioService.getAvailableLanguages();

      setState(() {
        _availableLanguages = languages;
      });
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _testTTS() async {
    final languageCode = context.read<LanguageProvider>().currentLanguageCode;
    await _audioService.speak('Teste de configuração do TTS', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        final translation = languageProvider.getTranslation;
        return Scaffold(
          appBar: DSHeader(
            title: translation('ui.settings'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: ListView(
            padding: const EdgeInsets.all(DesignTokens.spaceLG),
            children: [
              // Tema
              _buildSection(
                title: translation('ui.appearance'),
                icon: Icons.palette,
                children: [
                  SwitchListTile(
                    title: DSSubtitle(translation('ui.darkMode')),
                    subtitle:
                        DSBody(translation('ui.enableDarkMode'), small: true),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.setTheme(value);
                    },
                    secondary: DSIcon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                      icon3: true,
                    ),
                  ),
                ],
              ),

              const DSVerticalSpacing.xl2(),

              // Idioma
              _buildSection(
                title: translation('ui.language'),
                icon: Icons.language,
                children: [
                  for (final language in languageProvider.supportedLanguages)
                    RadioListTile<String>(
                      title: Text(language.nativeName),
                      subtitle: Text(language.name),
                      value: language.code,
                      groupValue: languageProvider.currentLanguageCode,
                      onChanged: (value) {
                        if (value != null) {
                          languageProvider.setLanguage(value, (languageCode) {
                            // Atualizar os itens de áudio quando o idioma muda
                            final parentalProvider =
                                context.read<ParentalConfigProvider>();
                            parentalProvider
                                .setCurrentLanguageCode(languageCode);
                            parentalProvider.updateLanguage(languageCode);
                          });
                          _audioService.setLanguage(value);
                        }
                      },
                      secondary: Icon(
                        Icons.flag,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),

              const DSVerticalSpacing.xl2(),

              // Configurações de TTS
              _buildSection(
                title: translation('ui.audioSettings'),
                icon: Icons.volume_up,
                children: [
                  // Taxa de fala
                  ListTile(
                    title: Text(translation('ui.speechRate')),
                    subtitle: Text('${(_speechRate * 100).round()}%'),
                    leading: const Icon(Icons.speed),
                    trailing: SizedBox(
                      width: 200,
                      child: Slider(
                        value: _speechRate,
                        min: 0.1,
                        max: 1.0,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            _speechRate = value;
                          });
                          _audioService.setSpeechRate(value);
                        },
                      ),
                    ),
                  ),

                  // Volume
                  ListTile(
                    title: Text(translation('ui.volume')),
                    subtitle: Text('${(_volume * 100).round()}%'),
                    leading: const Icon(Icons.volume_up),
                    trailing: SizedBox(
                      width: 200,
                      child: Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                          _audioService.setVolume(value);
                        },
                      ),
                    ),
                  ),

                  // Pitch
                  ListTile(
                    title: Text(translation('ui.pitch')),
                    subtitle: Text('${(_pitch * 100).round()}%'),
                    leading: const Icon(Icons.music_note),
                    trailing: SizedBox(
                      width: 200,
                      child: Slider(
                        value: _pitch,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        onChanged: (value) {
                          setState(() {
                            _pitch = value;
                          });
                          _audioService.setPitch(value);
                        },
                      ),
                    ),
                  ),

                  // Teste de TTS
                  ListTile(
                    title: Text(translation('ui.testTts')),
                    subtitle: Text(translation('ui.tapToTest')),
                    leading: const Icon(Icons.play_arrow),
                    trailing: IconButton(
                      onPressed: _testTTS,
                      icon: const Icon(Icons.volume_up),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const DSVerticalSpacing.xl2(),

              // Configuração Parental
              _buildSection(
                title: translation('ui.parentalConfig'),
                icon: Icons.family_restroom,
                children: [
                  DSListItem(
                    title: translation('ui.configureAudios'),
                    subtitle: translation('ui.configureAudiosDesc'),
                    trailing:
                        const DSIcon(Icons.arrow_forward_ios, icon2: true),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParentalConfigScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const DSVerticalSpacing.xl2(),

              // Permissões do App
              _buildSection(
                title: 'Permissões do App',
                icon: Icons.security,
                children: [
                  DSListItem(
                    title: 'Gerenciar Permissões',
                    subtitle: 'Verificar e solicitar permissões necessárias',
                    trailing:
                        const DSIcon(Icons.arrow_forward_ios, icon2: true),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PermissionsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const DSVerticalSpacing.xl2(),

              // Informações do app
              _buildSection(
                title: translation('ui.aboutApp'),
                icon: Icons.info,
                children: [
                  ListTile(
                    title: Text(translation('ui.version')),
                    subtitle: const Text('1.0.0'),
                    leading: const Icon(Icons.app_settings_alt),
                  ),
                  ListTile(
                    title: Text(translation('ui.developer')),
                    subtitle: const Text(
                        'Emir Marques de Liz with love for his son Miguel ❤️'),
                    leading: const Icon(Icons.developer_mode),
                  ),
                  ListTile(
                    title: Text(translation('ui.description')),
                    subtitle: Text(translation('ui.appDescription')),
                    leading: const Icon(Icons.description),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return DSCard(
      elev2: true,
      sp4: true,
      br3: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DSIcon(icon,
                  color: Theme.of(context).colorScheme.primary, icon3: true),
              const DSHorizontalSpacing.md(),
              DSTitle(title),
            ],
          ),
          const DSVerticalSpacing.lg(),
          ...children,
        ],
      ),
    );
  }
}
