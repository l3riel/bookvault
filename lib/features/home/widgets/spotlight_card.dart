import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/widgets/book_cover.dart';
import '../../../app/widgets/book_texts.dart';
import '../../../models/book.dart';

/// Destaque da Home: capa, título, autor, sinopse curta, "Ver livro" e 🔖.
class SpotlightCard extends StatelessWidget {
  const SpotlightCard({
    required this.book,
    required this.isSaved,
    required this.onOpen,
    required this.onSave,
    super.key,
  });

  final Book book;
  final bool isSaved;
  final VoidCallback onOpen;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final description = book.description;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 112,
                height: 168,
                child: BookCover(
                  title: book.title,
                  imageUrl: book.thumbnailUrl,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      authorsLabel(book),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSpacing.touchTarget,
                  child: FilledButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Ver livro'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox.square(
                dimension: AppSpacing.touchTarget,
                child: IconButton.outlined(
                  tooltip: isSaved
                      ? 'Já está na biblioteca'
                      : 'Salvar na biblioteca',
                  onPressed: isSaved ? null : onSave,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                    color: AppColors.brass,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
