import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// Script para gerar ícones PNG simples no estilo isométrico
// Execute com: dart tools/generate_icons.dart

void main() async {
  print('Gerando ícones PNG...');

  // Criar diretório se não existir
  final directory = Directory('assets/images/fun');
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  // Lista de ícones para gerar
  final icons = [
    'food',
    'drink',
    'bathroom',
    'sleep',
    'medicine',
    'help',
    'happy',
    'sad',
    'angry',
    'scared',
    'excited',
    'tired',
    'play',
    'read',
    'draw',
    'toys',
    'hello',
    'love',
    'yes',
    'no',
    'da',
    'more',
  ];

  for (final iconName in icons) {
    await generateIcon(iconName);
    print('✓ Gerado: $iconName.png');
  }

  print('\n✅ Todos os ícones foram gerados em assets/images/fun/');
}

Future<void> generateIcon(String name) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(64, 64);

  // Fundo transparente
  canvas.drawColor(Colors.transparent, ui.BlendMode.clear);

  // Gerar ícone baseado no nome
  switch (name) {
    case 'food':
      drawFoodIcon(canvas, size);
      break;
    case 'drink':
      drawDrinkIcon(canvas, size);
      break;
    case 'read':
      drawReadIcon(canvas, size);
      break;
    case 'play':
      drawPlayIcon(canvas, size);
      break;
    case 'draw':
      drawDrawIcon(canvas, size);
      break;
    case 'toys':
      drawToysIcon(canvas, size);
      break;
    case 'bathroom':
      drawBathroomIcon(canvas, size);
      break;
    case 'sleep':
      drawSleepIcon(canvas, size);
      break;
    case 'medicine':
      drawMedicineIcon(canvas, size);
      break;
    case 'happy':
      drawHappyIcon(canvas, size);
      break;
    case 'sad':
      drawSadIcon(canvas, size);
      break;
    case 'angry':
      drawAngryIcon(canvas, size);
      break;
    case 'scared':
      drawScaredIcon(canvas, size);
      break;
    case 'excited':
      drawExcitedIcon(canvas, size);
      break;
    case 'tired':
      drawTiredIcon(canvas, size);
      break;
    case 'hello':
      drawHelloIcon(canvas, size);
      break;
    case 'love':
      drawLoveIcon(canvas, size);
      break;
    case 'yes':
      drawYesIcon(canvas, size);
      break;
    case 'no':
      drawNoIcon(canvas, size);
      break;
    case 'da':
      drawDaIcon(canvas, size);
      break;
    case 'more':
      drawMoreIcon(canvas, size);
      break;
    case 'help':
      drawHelpIcon(canvas, size);
      break;
    default:
      drawDefaultIcon(canvas, size, name);
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(64, 64);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();

  final file = File('assets/images/fun/$name.png');
  await file.writeAsBytes(bytes);
}

void drawFoodIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Prato
  paint.color = const Color(0xFFE8F5E8);
  canvas.drawOval(const Rect.fromLTWH(8, 32, 48, 24), paint);

  // Comida
  paint.color = const Color(0xFFFF6B35);
  canvas.drawOval(const Rect.fromLTWH(16, 36, 32, 16), paint);

  // Talheres
  paint.color = const Color(0xFF4A4A4A);
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;

  // Garfo
  canvas.drawLine(const Offset(12, 16), const Offset(12, 40), paint);
  canvas.drawLine(const Offset(8, 16), const Offset(16, 16), paint);
  canvas.drawLine(const Offset(8, 20), const Offset(16, 20), paint);

  // Faca
  canvas.drawLine(const Offset(52, 16), const Offset(52, 40), paint);
  canvas.drawLine(const Offset(48, 16), const Offset(56, 16), paint);
}

void drawDrinkIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Copo
  paint.color = const Color(0xFFE3F2FD);
  final cupPath = Path()
    ..moveTo(16, 40)
    ..lineTo(16, 24)
    ..lineTo(24, 16)
    ..lineTo(40, 16)
    ..lineTo(48, 24)
    ..lineTo(48, 40)
    ..close();
  canvas.drawPath(cupPath, paint);

  // Bebida
  paint.color = const Color(0xFF81C784);
  canvas.drawRect(const Rect.fromLTWH(20, 28, 24, 12), paint);

  // Canudo
  paint.color = const Color(0xFFFF9800);
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;
  canvas.drawLine(const Offset(32, 12), const Offset(32, 24), paint);
}

void drawReadIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Cores dos livros
  final colors = [
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFF45B7D1),
    const Color(0xFF96CEB4),
  ];

  // Pilha de livros
  for (int i = 0; i < 4; i++) {
    paint.color = colors[i % colors.length];
    final left = 8.0 + (i * 4.0);
    final top = 16.0 - (i * 3.0);
    final width = 48.0 - (i * 2.0);
    const height = 32.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, width, height),
        const Radius.circular(4),
      ),
      paint,
    );

    // Páginas
    paint.color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + width - 4, top + 2, 4, height - 4),
        const Radius.circular(2),
      ),
      paint,
    );
  }
}

void drawPlayIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Console
  paint.color = const Color(0xFF424242);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(12, 32, 40, 24),
      const Radius.circular(8),
    ),
    paint,
  );

  // Tela
  paint.color = const Color(0xFF4CAF50);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(16, 36, 32, 16),
      const Radius.circular(4),
    ),
    paint,
  );

  // Botões
  paint.color = const Color(0xFFFF5722);
  canvas.drawCircle(const Offset(24, 44), 3, paint);
  canvas.drawCircle(const Offset(40, 44), 3, paint);
}

void drawDrawIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Paleta
  paint.color = const Color(0xFF424242);
  canvas.drawOval(const Rect.fromLTWH(16, 24, 32, 32), paint);

  // Cores
  final colors = [
    const Color(0xFFFF5722),
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFFFEB3B),
  ];

  for (int i = 0; i < 4; i++) {
    paint.color = colors[i];
    canvas.drawCircle(
      Offset(24 + (i * 4), 32 + (i * 4)),
      4,
      paint,
    );
  }

  // Pincel
  paint.color = const Color(0xFF8D6E63);
  paint.strokeWidth = 6;
  paint.style = PaintingStyle.stroke;
  canvas.drawLine(const Offset(40, 16), const Offset(48, 24), paint);
}

void drawToysIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  final colors = [
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFFFD93D),
    const Color(0xFF6C5CE7),
  ];

  // Blocos
  paint.color = colors[0];
  canvas.drawRect(const Rect.fromLTWH(12, 36, 16, 16), paint);

  paint.color = colors[1];
  canvas.drawRect(const Rect.fromLTWH(24, 28, 16, 16), paint);

  paint.color = colors[2];
  canvas.drawRect(const Rect.fromLTWH(36, 20, 16, 16), paint);

  // Detalhes
  paint.color = colors[3];
  canvas.drawCircle(const Offset(20, 44), 2, paint);
  canvas.drawCircle(const Offset(32, 36), 2, paint);
  canvas.drawCircle(const Offset(44, 28), 2, paint);
}

void drawBathroomIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Vaso
  paint.color = const Color(0xFFE8F5E8);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(16, 32, 32, 24),
      const Radius.circular(8),
    ),
    paint,
  );

  // Assento
  paint.color = const Color(0xFF4CAF50);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 36, 24, 16),
      const Radius.circular(4),
    ),
    paint,
  );

  // Detalhes
  paint.color = const Color(0xFF2E7D32);
  canvas.drawCircle(const Offset(32, 44), 2, paint);
}

void drawSleepIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Cama
  paint.color = const Color(0xFF8D6E63);
  canvas.drawRect(const Rect.fromLTWH(12, 36, 40, 20), paint);

  // Travesseiro
  paint.color = const Color(0xFFE3F2FD);
  canvas.drawOval(const Rect.fromLTWH(16, 40, 16, 12), paint);

  // Cobertor
  paint.color = const Color(0xFF4CAF50);
  canvas.drawRect(const Rect.fromLTWH(32, 40, 16, 12), paint);

  // Z's
  paint.color = const Color(0xFFFF9800);
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;
  canvas.drawLine(const Offset(48, 16), const Offset(52, 20), paint);
  canvas.drawLine(const Offset(52, 20), const Offset(48, 24), paint);
  canvas.drawLine(const Offset(48, 24), const Offset(52, 28), paint);
}

void drawMedicineIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Frasco
  paint.color = const Color(0xFFE3F2FD);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 24, 24, 32),
      const Radius.circular(4),
    ),
    paint,
  );

  // Tampa
  paint.color = const Color(0xFF424242);
  canvas.drawRect(const Rect.fromLTWH(22, 20, 20, 8), paint);

  // Líquido
  paint.color = const Color(0xFF81C784);
  canvas.drawRect(const Rect.fromLTWH(24, 32, 16, 20), paint);

  // Cruz
  paint.color = const Color(0xFFE57373);
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;
  canvas.drawLine(const Offset(32, 36), const Offset(32, 44), paint);
  canvas.drawLine(const Offset(28, 40), const Offset(36, 40), paint);
}

void drawHappyIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Rosto
  paint.color = const Color(0xFFFFD93D);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Olhos
  paint.color = const Color(0xFF424242);
  canvas.drawCircle(const Offset(26, 28), 3, paint);
  canvas.drawCircle(const Offset(38, 28), 3, paint);

  // Sorriso
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;
  canvas.drawArc(
    const Rect.fromLTWH(22, 30, 20, 12),
    0,
    3.14,
    false,
    paint,
  );
}

void drawSadIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Rosto
  paint.color = const Color(0xFF90CAF9);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Olhos
  paint.color = const Color(0xFF424242);
  canvas.drawCircle(const Offset(26, 28), 3, paint);
  canvas.drawCircle(const Offset(38, 28), 3, paint);

  // Boca triste
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;
  canvas.drawArc(
    const Rect.fromLTWH(22, 36, 20, 12),
    3.14,
    3.14,
    false,
    paint,
  );
}

void drawAngryIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Rosto
  paint.color = const Color(0xFFFF5722);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Olhos
  paint.color = const Color(0xFF424242);
  canvas.drawCircle(const Offset(26, 28), 3, paint);
  canvas.drawCircle(const Offset(38, 28), 3, paint);

  // Sobrancelhas
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;
  canvas.drawLine(const Offset(20, 24), const Offset(28, 28), paint);
  canvas.drawLine(const Offset(36, 28), const Offset(44, 24), paint);

  // Boca
  canvas.drawLine(const Offset(26, 40), const Offset(38, 40), paint);
}

void drawScaredIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Rosto
  paint.color = const Color(0xFFE1BEE7);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Olhos grandes
  paint.color = const Color(0xFF424242);
  canvas.drawCircle(const Offset(26, 28), 4, paint);
  canvas.drawCircle(const Offset(38, 28), 4, paint);

  // Boca assustada
  paint.color = const Color(0xFFFF5722);
  canvas.drawOval(const Rect.fromLTWH(28, 36, 8, 8), paint);
}

void drawExcitedIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Rosto
  paint.color = const Color(0xFFFFEB3B);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Olhos
  paint.color = const Color(0xFF424242);
  canvas.drawCircle(const Offset(26, 28), 3, paint);
  canvas.drawCircle(const Offset(38, 28), 3, paint);

  // Sorriso grande
  paint.strokeWidth = 4;
  paint.style = PaintingStyle.stroke;
  canvas.drawArc(
    const Rect.fromLTWH(20, 28, 24, 16),
    0,
    3.14,
    false,
    paint,
  );
}

void drawTiredIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Rosto
  paint.color = const Color(0xFFBDBDBD);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Olhos fechados
  paint.color = const Color(0xFF424242);
  paint.strokeWidth = 3;
  paint.style = PaintingStyle.stroke;
  canvas.drawLine(const Offset(22, 28), const Offset(30, 28), paint);
  canvas.drawLine(const Offset(34, 28), const Offset(42, 28), paint);

  // Boca neutra
  canvas.drawLine(const Offset(28, 40), const Offset(36, 40), paint);
}

void drawHelloIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Mão
  paint.color = const Color(0xFFFFCC80);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Dedos
  paint.color = const Color(0xFFFFAB40);
  canvas.drawCircle(const Offset(32, 16), 6, paint);
  canvas.drawCircle(const Offset(24, 20), 4, paint);
  canvas.drawCircle(const Offset(40, 20), 4, paint);
  canvas.drawCircle(const Offset(20, 28), 4, paint);
  canvas.drawCircle(const Offset(44, 28), 4, paint);
}

void drawLoveIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Coração
  paint.color = const Color(0xFFE91E63);
  final heartPath = Path()
    ..moveTo(32, 44)
    ..cubicTo(24, 36, 16, 28, 16, 20)
    ..cubicTo(16, 12, 24, 12, 28, 20)
    ..cubicTo(32, 12, 40, 12, 40, 20)
    ..cubicTo(40, 28, 32, 36, 32, 44);
  canvas.drawPath(heartPath, paint);
}

void drawYesIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Polegar para cima
  paint.color = const Color(0xFF4CAF50);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(24, 16, 16, 32),
      const Radius.circular(8),
    ),
    paint,
  );

  // Detalhes
  paint.color = const Color(0xFF2E7D32);
  canvas.drawCircle(const Offset(32, 24), 4, paint);
}

void drawNoIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Polegar para baixo
  paint.color = const Color(0xFFF44336);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(24, 16, 16, 32),
      const Radius.circular(8),
    ),
    paint,
  );

  // Detalhes
  paint.color = const Color(0xFFD32F2F);
  canvas.drawCircle(const Offset(32, 40), 4, paint);
}

void drawDaIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Mão
  paint.color = const Color(0xFFFFCC80);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 20, 24, 24),
      const Radius.circular(8),
    ),
    paint,
  );

  // Dedos
  paint.color = const Color(0xFFFFAB40);
  canvas.drawCircle(const Offset(32, 16), 6, paint);
  canvas.drawCircle(const Offset(24, 24), 4, paint);
  canvas.drawCircle(const Offset(40, 24), 4, paint);
}

void drawMoreIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Círculo base
  paint.color = const Color(0xFF4CAF50);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Símbolo de mais
  paint.color = Colors.white;
  canvas.drawRect(const Rect.fromLTWH(30, 20, 4, 24), paint);
  canvas.drawRect(const Rect.fromLTWH(20, 30, 24, 4), paint);
}

void drawHelpIcon(Canvas canvas, Size size) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Círculo
  paint.color = const Color(0xFF2196F3);
  canvas.drawCircle(const Offset(32, 32), 20, paint);

  // Ponto de interrogação
  paint.color = Colors.white;
  canvas.drawCircle(const Offset(32, 24), 3, paint);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(30, 32, 4, 12),
      const Radius.circular(2),
    ),
    paint,
  );
  canvas.drawCircle(const Offset(32, 48), 2, paint);
}

void drawDefaultIcon(Canvas canvas, Size size, String name) {
  final paint = Paint()..style = PaintingStyle.fill;

  // Container colorido
  paint.color = const Color(0xFF4CAF50);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(8, 8, 48, 48),
      const Radius.circular(8),
    ),
    paint,
  );

  // Texto
  final textPainter = TextPainter(
    text: TextSpan(
      text: name.substring(0, 1).toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    ),
  );
}
