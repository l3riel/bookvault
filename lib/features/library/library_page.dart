import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/widgets/brand_app_bar.dart';
import '../../app/widgets/confirm_removal_dialog.dart';
import '../../models/user_book.dart';
import '../../stores/library_store.dart';
import 'widgets/book_actions_sheet.dart';
import 'widgets/library_book_card.dart';
import 'widgets/library_empty_state.dart';
import 'widgets/library_filter_bar.dart';

/// Aba Biblioteca: livros salvos, filtros e ações (S06). Funciona offline.
class LibraryPage extends StatelessWidget {
  const LibraryPage({required this.store, super.key});

  final LibraryStore store;

  Future<void> _openActions(BuildContext context, UserBook userBook) async {
    final action = await showBookActionsSheet(context, userBook);
    if (!context.mounted || action == null) return;
    switch (action) {
      case ChangeStatusAction(:final status):
        await store.changeStatus(userBook.id, status);
      case RemoveBookAction():
        if (await confirmRemoval(context, userBook.book.title)) {
          await store.remove(userBook.id);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const BrandAppBar(),
      body: Observer(
        builder: (context) {
          if (store.total == 0) {
            return LibraryEmptyState(
              onExplore: () => context.go(AppRoutes.explore),
            );
          }
          final filter = store.filter;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  AppSpacing.sm,
                  AppSpacing.screenMargin,
                  AppSpacing.md,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minha biblioteca', style: textTheme.displayMedium),
                      Text(
                        store.total == 1
                            ? '1 livro na biblioteca'
                            : '${store.total} livros na biblioteca',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: LibraryFilterBar(store: store)),
              if (filter != null && store.filteredCount == 0)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenMargin,
                    AppSpacing.md,
                    AppSpacing.screenMargin,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Nenhum livro em ${filter.label}.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenMargin),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.gutter,
                    crossAxisSpacing: AppSpacing.gutter,
                    childAspectRatio: 0.52,
                  ),
                  itemCount: store.books.length,
                  itemBuilder: (context, index) {
                    final userBook = store.books[index];
                    return LibraryBookCard(
                      userBook: userBook,
                      highlighted: store.isHighlighted(userBook),
                      onTap: () =>
                          context.push(AppRoutes.bookDetailsOf(userBook.id)),
                      onOptions: () => _openActions(context, userBook),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
