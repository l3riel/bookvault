import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

/// Chip de gênero: pílula neutra, ou brass com ✓ quando selecionado.
class GenreChip extends StatelessWidget {
  const GenreChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: true,
      checkmarkColor: AppColors.brass,
      labelStyle: AppTypography.labelLarge.copyWith(
        color: selected ? AppColors.brass : AppColors.textMuted,
      ),
      side: BorderSide(
        color: selected
            ? AppColors.brass.withValues(alpha: 0.6)
            : AppColors.borderSubtle,
      ),
    );
  }
}
