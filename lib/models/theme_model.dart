import 'package:flutter/material.dart';

class AppTheme {
  final Color primary;
  final Color surface;
  final Color background;
  final Color text;
  final Color textSecondary;
  final Color textInverse;
  final Color success;
  final Color error;
  final Color warning;

  const AppTheme({
    required this.primary,
    required this.surface,
    required this.background,
    required this.text,
    required this.textSecondary,
    required this.textInverse,
    required this.success,
    required this.error,
    required this.warning,
  });

  static const AppTheme light = AppTheme(
    primary: Color(0xFF007AFF),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF5F5F5),
    text: Color(0xFF000000),
    textSecondary: Color(0xFF666666),
    textInverse: Color(0xFFFFFFFF),
    success: Color(0xFF34C759),
    error: Color(0xFFFF3B30),
    warning: Color(0xFFFF9500),
  );

  static const AppTheme dark = AppTheme(
    primary: Color(0xFF0A84FF),
    surface: Color(0xFF1C1C1E),
    background: Color(0xFF000000),
    text: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF8E8E93),
    textInverse: Color(0xFF000000),
    success: Color(0xFF30D158),
    error: Color(0xFFFF453A),
    warning: Color(0xFFFF9F0A),
  );

  Color getItemColor(String type) {
    switch (type) {
      case 'basic':
        return primary;
      case 'emotions':
        return const Color(0xFFDB2777);
      case 'activities':
        return success;
      case 'social':
        return const Color(0xFF9333EA);
      default:
        return textSecondary;
    }
  }
}
