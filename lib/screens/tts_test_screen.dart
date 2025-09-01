import 'package:flutter/material.dart';
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
      await _audioService.speak('Teste básico do TTS');
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
      await _audioService.speak('Teste com velocidade lenta, volume médio e tom alto');
      
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
      appBar: AppBar(
        title: const Text('Teste TTS'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _isSpeaking ? Icons.volume_up : Icons.volume_off,
                      size: 48,
                      color: _isSpeaking 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botões de teste
            ElevatedButton.icon(
              onPressed: _isSpeaking ? null : _testBasicTTS,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Teste Básico'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isSpeaking ? null : _testWithOptions,
              icon: const Icon(Icons.tune),
              label: const Text('Teste com Opções'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isSpeaking ? null : _testDifferentLanguages,
              icon: const Icon(Icons.language),
              label: const Text('Teste de Idiomas (4 idiomas)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isSpeaking ? _stopSpeech : null,
              icon: const Icon(Icons.stop),
              label: const Text('Parar Fala'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
            ),

            const Spacer(),

            // Informações
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações do TTS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Toque nos botões para testar diferentes funcionalidades'),
                    const Text('• Use o botão "Parar Fala" para interromper o TTS'),
                    const Text('• Teste 4 idiomas: Português, Inglês, Espanhol e Alemão'),
                    const Text('• Verifique se o som está funcionando corretamente'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
