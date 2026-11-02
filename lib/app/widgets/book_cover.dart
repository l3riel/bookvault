import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Capa de livro (cantos de 4px). Sem URL, sem internet ou enquanto carrega,
/// mostra um marcador com o título.
class BookCover extends StatelessWidget {
  const BookCover({required this.title, this.imageUrl, super.key});

  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final placeholder = _CoverPlaceholder(title: title);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: url == null
          ? placeholder
          : Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              semanticLabel: 'Capa de $title',
              errorBuilder: (context, error, stackTrace) => placeholder,
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : placeholder,
            ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('book-cover-placeholder'),
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceElevated,
      padding: const EdgeInsets.all(AppSpacing.sm),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book_outlined, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
