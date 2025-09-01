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
      print('🔍 Testing TTS with language: $languageCode');
      
      // Teste simples primeiro
      await _audioService.speak('Olá', languageCode);
      await Future.delayed(Duration(seconds: 2));
      
      // Teste em inglês se não for português
      if (languageCode != 'pt-BR') {
        await _audioService.speak('Hello', 'en');
      }
      
      setState(() {
        _status = 'Teste concluído! Verifique o console para logs.';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro no teste: $e';
      });
      print('❌ TTS Test Error: $e');
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

  Future<void> _checkTTSStatus() async {
    setState(() {
      _status = 'Verificando status...';
    });

    try {
      final languageCode = context.read<LanguageProvider>().currentLanguageCode;
      final voices = await _audioService.getAvailableVoices();
      final languages = await _audioService.getAvailableLanguages();
      
      print('🔍 TTS Status Check:');
      print('🌍 Current Language: $languageCode');
      print('🎤 Available Voices: ${voices.length}');
      print('🌍 Available Languages: ${languages.length}');
      
      if (voices.isNotEmpty) {
        print('🎤 First Voice: ${voices.first}');
      }
      
      setState(() {
        _status = 'Status verificado! Verifique o console.';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao verificar status: $e';
      });
      print('❌ Status Check Error: $e');
    }
  }

  Future<void> _checkDeviceTTS() async {
    setState(() {
      _status = 'Verificando TTS do dispositivo...';
    });

    try {
      // Verificar TTS básico
      final isAvailable = await _audioService.isTTSAvailable();
      print('🔍 Basic TTS Check: $isAvailable');
      
      // Verificar idiomas disponíveis
      final languages = await _audioService.getAvailableLanguages();
      print('🌍 Available Languages: ${languages.length}');
      
      // Verificar vozes disponíveis
      final voices = await _audioService.getAvailableVoices();
      print('🎤 Available Voices: ${voices.length}');
      
      // Verificar se o dispositivo tem TTS instalado
      bool hasTTS = false;
      try {
        hasTTS = await _audioService.checkLanguageAvailability('en');
        print('🔍 Device TTS Engine: $hasTTS');
      } catch (e) {
        print('❌ TTS Engine Check Failed: $e');
      }
      
      if (isAvailable && hasTTS && voices.isNotEmpty) {
        setState(() {
          _status = '✅ TTS funcionando! ${voices.length} vozes, ${languages.length} idiomas';
        });
        print('✅ TTS is working properly');
      } else {
        setState(() {
          _status = '❌ TTS com problemas: Vozes=${voices.length}, Idiomas=${languages.length}';
        });
        print('❌ TTS has issues');
      }
    } catch (e) {
      setState(() {
        _status = 'Erro ao verificar TTS: $e';
      });
      print('❌ Device TTS Check Error: $e');
    }
  }

  Future<void> _testDirectTTS() async {
    setState(() {
      _isSpeaking = true;
      _status = 'Testando TTS direto...';
    });

    try {
      print('🔄 Starting direct TTS test...');
      
      // Teste 1: TTS básico sem inicialização
      try {
        await _audioService.speakDirect('Teste direto');
        print('✅ Direct TTS test 1 passed');
        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        print('❌ Direct TTS test 1 failed: $e');
      }
      
      // Teste 2: Com inicialização
      try {
        await _audioService.initialize();
        await _audioService.speakDirect('Teste com inicialização');
        print('✅ Direct TTS test 2 passed');
        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        print('❌ Direct TTS test 2 failed: $e');
      }
      
      // Teste 3: Com idioma específico
      try {
        await _audioService.setLanguageDirect('en');
        await _audioService.speakDirect('Hello world');
        print('✅ Direct TTS test 3 passed');
      } catch (e) {
        print('❌ Direct TTS test 3 failed: $e');
      }
      
      setState(() {
        _status = 'Teste direto concluído! Verifique o console.';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro no teste direto: $e';
      });
      print('❌ Direct TTS Test Error: $e');
    } finally {
      setState(() {
        _isSpeaking = false;
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
              text: 'Verificar Status TTS',
              icon: Icons.info,
              primary: false,
              large: true,
              onPressed: _checkTTSStatus,
            ),

            const DSVerticalSpacing.md(),

            DSButton(
              text: 'Verificar TTS do Dispositivo',
              icon: Icons.phone_android,
              primary: false,
              large: true,
              onPressed: _checkDeviceTTS,
            ),

            const DSVerticalSpacing.md(),

            DSButton(
              text: 'Teste Direto TTS',
              icon: Icons.record_voice_over,
              primary: true,
              large: true,
              onPressed: _testDirectTTS,
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
