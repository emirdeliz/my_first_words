import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Gerando áudios MP3...');

  String? inputFilePath;
  String? wordsCsv;
  String language = 'pt-BR';
  String voiceProfile = 'female'; // female | male
  String outputDirPath = 'assets/audio';

  for (final arg in args) {
    if (arg.startsWith('--input=')) {
      inputFilePath = arg.substring('--input='.length);
    } else if (arg.startsWith('--words=')) {
      wordsCsv = arg.substring('--words='.length);
    } else if (arg.startsWith('--lang=')) {
      language = arg.substring('--lang='.length);
    } else if (arg.startsWith('--voice=')) {
      voiceProfile = arg.substring('--voice='.length);
    } else if (arg.startsWith('--output=')) {
      outputDirPath = arg.substring('--output='.length);
    } else if (arg == '--help' || arg == '-h') {
      print(
          '\nUso: flutter run -d macos -t tools/generate_mp3.dart -- --input=tools/words.txt --lang=pt-BR --voice=female --output=assets/audio');
      print(
          '     flutter run -d macos -t tools/generate_mp3.dart -- --words=ola,tchau,comida --lang=pt-BR --voice=male --output=assets/audio');
      return;
    }
  }

  final List<String> words;
  if (inputFilePath != null && inputFilePath!.isNotEmpty) {
    final file = File(inputFilePath!);
    if (!await file.exists()) {
      stderr.writeln('Arquivo não encontrado: $inputFilePath');
      return;
    }
    words = (await file.readAsLines())
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  } else if (wordsCsv != null && wordsCsv!.isNotEmpty) {
    words = wordsCsv!
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  } else {
    words = ['comida', 'beber', 'banheiro', 'dormir'];
  }

  // Resolver diretório de saída: sandbox no Android/iOS; caminho do projeto no desktop
  Directory outDir;
  if (Platform.isAndroid) {
    final ext = await getExternalStorageDirectory();
    outDir = Directory('${ext!.path}/$outputDirPath');
  } else if (Platform.isIOS) {
    final docs = await getApplicationDocumentsDirectory();
    outDir = Directory('${docs.path}/$outputDirPath');
  } else {
    if (outputDirPath.startsWith('/') || outputDirPath.startsWith('~')) {
      outDir = Directory(
          outputDirPath.replaceFirst('~', Platform.environment['HOME'] ?? '~'));
    } else {
      Directory dir = Directory.fromUri(Platform.script).parent; // tools/
      while (true) {
        final pubspec = File('${dir.path}/pubspec.yaml');
        if (pubspec.existsSync()) break;
        final parent = dir.parent;
        if (parent.path == dir.path) break;
        dir = parent;
      }
      outDir = Directory('${dir.path}/$outputDirPath');
    }
  }
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  final tts = FlutterTts();
  await tts.setLanguage(language);
  await tts.setSpeechRate(0.5);
  await tts.setVolume(1.0);
  await tts.setPitch(1.0);

  // Tentar escolher uma voz por perfil
  try {
    final voices = await tts.getVoices;
    if (voices is List) {
      Map<String, dynamic>? selected;
      bool matchesLang(Map<dynamic, dynamic> v) {
        final name = (v['name'] ?? '').toString().toLowerCase();
        final locale = (v['locale'] ?? '').toString().toLowerCase();
        final tgt = language.toLowerCase();
        if (tgt == 'pt-br' || tgt == 'pt_br') {
          final isPtBr = locale.contains('pt-br') ||
              locale.contains('pt_br') ||
              name.contains('pt-br') ||
              name.contains('pt_br') ||
              name.contains('brazil');
          final isPtPt = locale.contains('pt-pt') ||
              locale.contains('pt_pt') ||
              name.contains('pt-pt') ||
              name.contains('pt_pt') ||
              name.contains('portugal');
          return isPtBr && !isPtPt;
        }
        return locale.contains(tgt) || name.contains(tgt);
      }

      for (final v in voices) {
        if (v is Map && matchesLang(v.cast())) {
          final m = v.cast<String, dynamic>();
          final gender = (m['gender'] ?? '').toString().toLowerCase();
          final name = (m['name'] ?? '').toString().toLowerCase();
          if (voiceProfile == 'female' &&
              (gender.contains('female') ||
                  name.contains('female') ||
                  name.contains('fem'))) {
            selected = m;
            break;
          }
          if (voiceProfile == 'male' &&
              (gender.contains('male') ||
                  name.contains('male') ||
                  name.contains('masc'))) {
            selected = m;
            break;
          }
        }
      }
      selected ??=
          (voices.cast<Map>().map((e) => e.cast<String, dynamic>()).firstWhere(
                (e) => matchesLang(e),
                orElse: () => <String, dynamic>{},
              ));
      if (selected.isNotEmpty) {
        await tts
            .setVoice({'name': selected['name'], 'locale': selected['locale']});
      }
    }
  } catch (_) {}

  for (final w in words) {
    final safeName = w
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_\-]+', caseSensitive: false), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final filePath = '${outDir.path}/$safeName.mp3';
    print('→ Gerando "$w" → $filePath');
    final res = await tts.synthesizeToFile(w, filePath);
    if (res == 1) {
      print('✓ Gerado: $filePath');
    } else {
      print('⚠️ Falha ao gerar: $filePath');
    }
  }

  print('\n✅ Concluído. Arquivos em: ${outDir.path}');
}
