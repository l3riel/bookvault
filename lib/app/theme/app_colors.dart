import 'package:flutter/material.dart';

/// Paleta do design system Nocturne Editorial (ver `DESIGN.md`).
abstract final class AppColors {
  // Superfícies (camadas de profundidade).
  static const Color surfaceBase = Color(0xFF121214);
  static const Color surfaceRaised = Color(0xFF1C1C20);
  static const Color surfaceElevated = Color(0xFF26262C);
  static const Color navigationBar = Color(0xFF161619);
  static const Color borderSubtle = Color(0xFF2E2E36);

  // Texto.
  static const Color textParchment = Color(0xFFF4EFEA);
  static const Color textMuted = Color(0xFF9E9EA8);

  // Acentos.
  static const Color brass = Color(0xFFD4AF37);
  static const Color brassHover = Color(0xFFE5C158);
  static const Color onBrass = Color(0xFF121214);
  static const Color amethyst = Color(0xFF8B3FB8);
  static const Color sage = Color(0xFF71B943);

  // Erro.
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
}
