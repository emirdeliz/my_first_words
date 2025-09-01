import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../services/audio_service.dart';
import 'parental_config_screen.dart';

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
    await _audioService.speak('Teste de configuração do TTS');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Tema
              _buildSection(
                title: 'Aparência',
                icon: Icons.palette,
                children: [
                  SwitchListTile(
                    title: const Text('Modo escuro'),
                    subtitle: const Text('Ativar tema escuro'),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.setTheme(value);
                    },
                    secondary: Icon(
                      themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Idioma
              _buildSection(
                title: 'Idioma',
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
                          languageProvider.setLanguage(value);
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

              const SizedBox(height: 24),

              // Configurações de TTS
              _buildSection(
                title: 'Configurações de Áudio',
                icon: Icons.volume_up,
                children: [
                  // Taxa de fala
                  ListTile(
                    title: const Text('Velocidade da fala'),
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
                    title: const Text('Volume'),
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
                    title: const Text('Tom da voz'),
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
                    title: const Text('Testar TTS'),
                    subtitle: const Text('Toque para testar as configurações'),
                    leading: const Icon(Icons.play_arrow),
                    trailing: IconButton(
                      onPressed: _testTTS,
                      icon: const Icon(Icons.volume_up),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Configuração Parental
              _buildSection(
                title: 'Configuração Parental',
                icon: Icons.family_restroom,
                children: [
                  ListTile(
                    title: const Text('Configurar Áudios Disponíveis'),
                    subtitle: const Text('Configure quais áudios estarão disponíveis para a criança'),
                    trailing: const Icon(Icons.arrow_forward_ios),
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

              const SizedBox(height: 24),

              // Informações do app
              _buildSection(
                title: 'Sobre o App',
                icon: Icons.info,
                children: [
                  ListTile(
                    title: const Text('Versão'),
                    subtitle: const Text('1.0.0'),
                    leading: const Icon(Icons.app_settings_alt),
                  ),
                  ListTile(
                    title: const Text('Desenvolvedor'),
                    subtitle: const Text('My First Words Team'),
                    leading: const Icon(Icons.developer_mode),
                  ),
                  ListTile(
                    title: const Text('Descrição'),
                    subtitle: const Text('Aplicativo de comunicação alternativa para crianças autistas'),
                    leading: const Icon(Icons.description),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
