import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

/// Saudação pelo nome e campo de busca falso que leva ao Explorar.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.greeting,
    required this.onSearchTap,
    super.key,
  });

  final String greeting;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'O que vamos ler hoje?',
          style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          button: true,
          label: 'Buscar livros',
          child: Material(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              key: const ValueKey('home-search'),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: onSearchTap,
              child: SizedBox(
                height: AppSpacing.touchTarget,
                child: Row(
                  children: [
                    const SizedBox(width: AppSpacing.gutter),
                    const Icon(Icons.search, color: AppColors.textMuted),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Buscar por título ou autor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
