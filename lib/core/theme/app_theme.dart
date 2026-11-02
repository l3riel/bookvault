import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Tema único (escuro) do BookVault.
abstract final class AppTheme {
  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.brass,
      onPrimary: AppColors.onBrass,
      secondary: AppColors.amethyst,
      onSecondary: AppColors.textParchment,
      tertiary: AppColors.sage,
      onTertiary: AppColors.onBrass,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.surfaceBase,
      onSurface: AppColors.textParchment,
      onSurfaceVariant: AppColors.textMuted,
      surfaceContainerLow: AppColors.surfaceRaised,
      surfaceContainer: AppColors.surfaceRaised,
      surfaceContainerHigh: AppColors.surfaceElevated,
      outline: AppColors.borderSubtle,
      outlineVariant: AppColors.borderSubtle,
    );
    final textTheme = AppTypography.textTheme;
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceBase,
      fontFamily: AppTypography.sans,
      textTheme: textTheme,
      dividerColor: AppColors.borderSubtle,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceBase,
        foregroundColor: AppColors.textParchment,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.headlineMedium,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceRaised,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: AppColors.onBrass,
          minimumSize: const Size.fromHeight(AppSpacing.touchTarget),
          shape: buttonShape,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textParchment,
          minimumSize: const Size.fromHeight(AppSpacing.touchTarget),
          side: const BorderSide(color: AppColors.borderSubtle),
          shape: buttonShape,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceRaised,
        selectedColor: AppColors.brass.withValues(alpha: 0.12),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textMuted,
        ),
        secondaryLabelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.brass,
        ),
        side: const BorderSide(color: AppColors.borderSubtle),
        shape: const StadiumBorder(),
        showCheckmark: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceRaised,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textMuted,
        ),
        border: _inputBorder(AppColors.borderSubtle),
        enabledBorder: _inputBorder(AppColors.borderSubtle),
        focusedBorder: _inputBorder(AppColors.brass.withValues(alpha: 0.5)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppSpacing.navigationBarHeight,
        backgroundColor: AppColors.navigationBar,
        indicatorColor: AppColors.brass.withValues(alpha: 0.15),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTypography.labelMedium.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.brass
                : AppColors.textMuted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.brass
                : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide(color: color),
  );
}
