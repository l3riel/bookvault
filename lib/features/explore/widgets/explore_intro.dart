import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../models/genre.dart';

/// Explorar antes da primeira busca: dica e atalhos pelos gêneros do usuário.
class ExploreIntro extends StatelessWidget {
  const ExploreIntro({
    required this.genres,
    required this.onGenreTap,
    super.key,
  });

  final List<Genre> genres;
  final ValueChanged<Genre> onGenreTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Busque por título ou autor', style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Digite e toque em buscar no teclado.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
          if (genres.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text('Seus gêneros', style: textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final genre in genres)
                  ActionChip(
                    label: Text(genre.label),
                    onPressed: () => onGenreTap(genre),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
