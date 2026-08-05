import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF7B2FF7);
  static const primaryDark = Color(0xFF5B1FB5);
  static const primaryLight = Color(0xFFE8DDFC);
  static const background = Color(0xFFF8F7FC);
  static const cardWhite = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF1A1A2E);
  static const textGrey = Color(0xFF8E8E9E);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  static const gradientPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B3FF7), Color(0xFF5B1FB5)],
  );
}