import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/widgets/book_cover.dart';
import '../../../app/widgets/book_texts.dart';
import '../../../models/book.dart';

/// Topo dos Detalhes: capa grande, título, autores e "ano • editora • páginas".
class BookHero extends StatelessWidget {
  const BookHero({required this.book, super.key});

  final Book book;

  /// Só os metadados que existem, na ordem do protótipo.
  static List<String> metadataOf(Book book) {
    final date = book.publishedDate;
    final pages = book.pageCount;
    return [
      if (date != null && date.length >= 4) date.substring(0, 4),
      ?book.publisher,
      if (pages != null && pages > 0)
        pages == 1 ? '1 página' : '$pages páginas',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final metadata = metadataOf(book);
    return Column(
      children: [
        SizedBox(
          width: 192,
          height: 288,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xD9000000),
                  blurRadius: 36,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: BookCover(title: book.title, imageUrl: book.thumbnailUrl),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          book.title,
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          authorsLabel(book),
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
        if (metadata.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              metadata.join(' • '),
              textAlign: TextAlign.center,
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
