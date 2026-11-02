import 'package:bookvault/app/theme/app_colors.dart';
import 'package:bookvault/app/theme/app_theme.dart';
import 'package:bookvault/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme.dark', () {
    final theme = AppTheme.dark;

    test('usa o fundo base e o brass como cor primária', () {
      expect(theme.scaffoldBackgroundColor, const Color(0xFF121214));
      expect(theme.colorScheme.primary, const Color(0xFFD4AF37));
      expect(theme.brightness, Brightness.dark);
    });

    test('usa Newsreader nos títulos e DM Sans na interface', () {
      expect(theme.textTheme.headlineLarge?.fontFamily, AppTypography.serif);
      expect(theme.textTheme.bodyMedium?.fontFamily, AppTypography.sans);
      expect(theme.textTheme.bodyMedium?.color, AppColors.textParchment);
    });
  });
}
