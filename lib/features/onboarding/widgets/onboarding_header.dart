import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

/// Topo do onboarding: ícone, selo "Coleção particular", nome e descrição.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: const Icon(Icons.local_library, color: AppColors.brass),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'COLEÇÃO PARTICULAR',
          style: textTheme.labelSmall?.copyWith(color: AppColors.brass),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text('BookVault', style: textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Seu refúgio literário particular. Suas preferências ficam salvas '
          'no aparelho para personalizar as recomendações.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
