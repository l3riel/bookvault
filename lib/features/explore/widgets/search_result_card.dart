import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/widgets/book_cover.dart';
import '../../../app/widgets/book_texts.dart';
import '../../../app/widgets/status_badge.dart';
import '../../../models/book.dart';
import '../../../models/reading_status.dart';

/// Resultado da busca: capa, título e autor. Livro já salvo mostra o status.
class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    required this.book,
    required this.onTap,
    this.savedStatus,
    super.key,
  });

  final Book book;
  final ReadingStatus? savedStatus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final status = savedStatus;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: BookCover(
                    title: book.title,
                    imageUrl: book.thumbnailUrl,
                  ),
                ),
                if (status != null)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: StatusBadge(status: status),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall,
          ),
          Text(
            authorsLabel(book),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
