import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../design_system/design_system.dart';
import '../services/audio_service.dart';

class TTSTestScreen extends StatefulWidget {
  const TTSTestScreen({super.key});

  @override
  State<TTSTestScreen> createState() => _TTSTestScreenState();
}

class _TTSTestScreenState extends State<TTSTestScreen> {
  final AudioService _audioService = AudioService();
  bool _isSpeaking = false;
  String _status = 'Pronto para testar';

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    setState(() {
      _status = 'Inicializando...';
    });
    
    try {
      await _audioService.initialize();
      setState(() {
        _status = 'TTS inicializado com sucesso!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao inicializar TTS: $e';
      });
    }
  }

  Future<void> _testBasicTTS() async {
    setState(() {
      _isSpeaking = true;
      _status = 'Falando...';
    });

    try {
      final languageCode = context.read<LanguageProvider>().currentLanguageCode;
      await _audioService.speak('Teste básico do TTS', languageCode);
      setState(() {
        _status = 'Teste concluído!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro no teste: $e';
      });
    } finally {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Future<void> _testWithOptions() async {
    setState(() {
      _isSpeaking = true;
      _status = 'Testando com opções...';
    });

    try {
      await _audioService.setSpeechRate(0.3);
      await _audioService.setVolume(0.8);
      await _audioService.setPitch(1.2);
      final languageCode = context.read<LanguageProvider>().currentLanguageCode;
      await _audioService.speak('Teste com velocidade lenta, volume médio e tom alto', languageCode);
      
      setState(() {
        _status = 'Teste com opções concluído!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro no teste com opções: $e';
      });
    } finally {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Future<void> _testDifferentLanguages() async {
    setState(() {
      _isSpeaking = true;
      _status = 'Testando idiomas...';
    });

    try {
      // Teste em português
      await _audioService.setLanguage('pt-BR');
      await _audioService.speak('Olá, este é um teste em português');
      
      // Aguarda um pouco
      await Future.delayed(const Duration(seconds: 2));
      
      // Teste em inglês
      await _audioService.setLanguage('en');
      await _audioService.speak('Hello, this is a test in English');
      
      // Aguarda um pouco
      await Future.delayed(const Duration(seconds: 2));
      
      // Teste em espanhol
      await _audioService.setLanguage('es');
      await _audioService.speak('Hola, esta es una prueba en español');
      
      // Aguarda um pouco
      await Future.delayed(const Duration(seconds: 2));
      
      // Teste em alemão
      await _audioService.setLanguage('de');
      await _audioService.speak('Hallo, das ist ein Test auf Deutsch');
      
      setState(() {
        _status = 'Teste de idiomas concluído!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro no teste de idiomas: $e';
      });
    } finally {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Future<void> _stopSpeech() async {
    try {
      await _audioService.stop();
      setState(() {
        _status = 'Fala interrompida';
        _isSpeaking = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao parar: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSHeader(
        title: 'Teste TTS',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            DSCard(
              sp4: true,
              br3: true,
              child: Column(
                children: [
                  DSIcon(
                    _isSpeaking ? Icons.volume_up : Icons.volume_off,
                    icon7: true,
                    color: _isSpeaking 
                        ? Theme.of(context).colorScheme.primary 
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  const DSVerticalSpacing.sm(),
                  DSTitle(
                    _status,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const DSVerticalSpacing.xl2(),

            // Botões de teste
            DSButton(
              text: 'Teste Básico',
              icon: Icons.play_arrow,
              primary: true,
              large: true,
              onPressed: _isSpeaking ? null : _testBasicTTS,
            ),

            const DSVerticalSpacing.md(),

            DSButton(
              text: 'Teste com Opções',
              icon: Icons.tune,
              primary: true,
              large: true,
              onPressed: _isSpeaking ? null : _testWithOptions,
            ),

            const DSVerticalSpacing.md(),

            DSButton(
              text: 'Teste de Idiomas (4 idiomas)',
              icon: Icons.language,
              primary: true,
              large: true,
              onPressed: _isSpeaking ? null : _testDifferentLanguages,
            ),

            const DSVerticalSpacing.md(),

            DSButton(
              text: 'Parar Fala',
              icon: Icons.stop,
              danger: true,
              large: true,
              onPressed: _isSpeaking ? _stopSpeech : null,
            ),

            const Spacer(),

            // Informações
            DSCard(
              sp4: true,
              br3: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DSTitle('Informações do TTS'),
                  const DSVerticalSpacing.sm(),
                  const DSBody('• Toque nos botões para testar diferentes funcionalidades'),
                  const DSBody('• Use o botão "Parar Fala" para interromper o TTS'),
                  const DSBody('• Teste 4 idiomas: Português, Inglês, Espanhol e Alemão'),
                  const DSBody('• Verifique se o som está funcionando corretamente'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
