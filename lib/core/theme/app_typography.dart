import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Escala tipográfica do `DESIGN.md`: Newsreader para títulos e textos
/// literários, DM Sans para a interface.
abstract final class AppTypography {
  static const String serif = 'Newsreader';
  static const String sans = 'DM Sans';

  static final TextStyle displayLarge = _style(serif, 40, 400, 48, -0.02);
  static final TextStyle displayMobile = _style(serif, 32, 400, 40, -0.01);
  static final TextStyle headlineLarge = _style(serif, 28, 500, 36, -0.01);
  static final TextStyle headlineMedium = _style(serif, 22, 500, 28);
  static final TextStyle headlineSmall = _style(serif, 18, 600, 24);
  static final TextStyle bodyLarge = _style(serif, 18, 400, 28);
  static final TextStyle bodyMedium = _style(sans, 15, 400, 22);
  static final TextStyle bodySmall = _style(sans, 13, 400, 18);
  static final TextStyle labelLarge = _style(sans, 14, 600, 18, 0.01);
  static final TextStyle labelMedium = _style(sans, 12, 500, 16, 0.02);
  static final TextStyle labelSmall = _style(sans, 10, 700, 12, 0.05);

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMobile,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: headlineMedium,
    titleMedium: headlineSmall,
    titleSmall: labelLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  /// As fontes são variáveis: o peso vai em [FontVariation] além de
  /// [FontWeight], para valer em todas as plataformas.
  static TextStyle _style(
    String family,
    double size,
    int weight,
    double lineHeight, [
    double letterSpacingEm = 0,
  ]) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: FontWeight.values[weight ~/ 100 - 1],
      fontVariations: [FontVariation.weight(weight.toDouble())],
      height: lineHeight / size,
      letterSpacing: letterSpacingEm * size,
      color: AppColors.textParchment,
    );
  }
}
