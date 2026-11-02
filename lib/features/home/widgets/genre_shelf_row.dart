import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/widgets/book_cover.dart';
import '../../../app/widgets/book_texts.dart';
import '../../../app/widgets/status_badge.dart';
import '../../../models/book.dart';
import '../../../models/reading_status.dart';

/// Fileira horizontal de capas de um gênero.
class GenreShelfRow extends StatelessWidget {
  const GenreShelfRow({
    required this.books,
    required this.statusOf,
    required this.onBookTap,
    super.key,
  });

  final List<Book> books;

  /// Status do livro na biblioteca, ou `null` se não estiver salvo.
  final ReadingStatus? Function(Book book) statusOf;
  final ValueChanged<Book> onBookTap;

  static const double _coverWidth = 112;
  static const double _coverHeight = 168;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: _coverHeight + 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenMargin,
        ),
        itemCount: books.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.gutter),
        itemBuilder: (context, index) {
          final book = books[index];
          final status = statusOf(book);
          return SizedBox(
            width: _coverWidth,
            child: InkWell(
              onTap: () => onBookTap(book),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _coverHeight,
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
                            top: AppSpacing.xs,
                            left: AppSpacing.xs,
                            right: AppSpacing.xs,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: StatusBadge(status: status),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge,
                  ),
                  Text(
                    authorsLabel(book),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
