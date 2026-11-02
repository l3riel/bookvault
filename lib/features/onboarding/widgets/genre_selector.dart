import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../models/genre.dart';
import '../../../stores/onboarding_store.dart';
import 'genre_chip.dart';
import 'section_title.dart';

/// Seção de escolha de gêneros com contador de selecionados.
class GenreSelector extends StatelessWidget {
  const GenreSelector({required this.store, super.key});

  final OnboardingStore store;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Escolha seus gêneros favoritos',
            subtitle:
                'Escolha um ou mais para montar suas primeiras recomendações.',
            trailing: store.selectedCount > 0
                ? _CountBadge(count: store.selectedCount)
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final genre in Genre.values)
                GenreChip(
                  label: genre.label,
                  selected: store.selectedGenres.contains(genre),
                  onTap: () => store.toggleGenre(genre),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.brass.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        count == 1 ? '1 selecionado' : '$count selecionados',
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: AppColors.brass),
      ),
    );
  }
}
