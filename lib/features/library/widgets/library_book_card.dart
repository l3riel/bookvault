import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/widgets/book_cover.dart';
import '../../../app/widgets/status_badge.dart';
import '../../../models/user_book.dart';

/// Card da grade da biblioteca: capa com selo, título, autor e menu ⋮.
class LibraryBookCard extends StatelessWidget {
  const LibraryBookCard({
    required this.userBook,
    required this.highlighted,
    required this.onTap,
    required this.onOptions,
    super.key,
  });

  final UserBook userBook;

  /// `false` quando o filtro ativo é de outro status (card apagado).
  final bool highlighted;
  final VoidCallback onTap;
  final VoidCallback onOptions;

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;
    final textTheme = Theme.of(context).textTheme;
    return AnimatedOpacity(
      opacity: highlighted ? 1 : 0.35,
      duration: const Duration(milliseconds: 200),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onOptions,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
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
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatusBadge(status: userBook.status),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headlineSmall,
                          ),
                          Text(
                            book.authors.isEmpty
                                ? 'Autor desconhecido'
                                : book.authors.join(', '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: 'Opções de ${book.title}',
                        icon: const Icon(Icons.more_vert, size: 20),
                        color: AppColors.textMuted,
                        onPressed: onOptions,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
