import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/widgets/confirm_removal_dialog.dart';
import '../../app/widgets/state_message.dart';
import '../../models/book.dart';
import '../../stores/book_details_store.dart';
import 'widgets/book_hero.dart';
import 'widgets/details_section.dart';
import 'widgets/library_actions.dart';
import 'widgets/reading_status_selector.dart';

/// Detalhes de um livro: metadados e ações na biblioteca (S07).
class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({required this.createStore, super.key});

  final BookDetailsStore Function() createStore;

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late final BookDetailsStore _store = widget.createStore()..load();

  Future<void> _remove(Book book) async {
    if (await confirmRemoval(context, book.title)) {
      await _store.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: Observer(
        builder: (context) {
          final book = _store.book;
          switch (_store.status) {
            case BookDetailsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case BookDetailsStatus.error:
              return StateMessage(
                icon: Icons.cloud_off_outlined,
                title: 'Não foi possível abrir o livro',
                message: _store.errorMessage ?? '',
                actionLabel: 'Tentar de novo',
                onAction: _store.load,
              );
            case BookDetailsStatus.loaded:
              return _content(book!);
          }
        },
      ),
    );
  }

  Widget _content(Book book) {
    final saved = _store.savedBook;
    final description = book.description;
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.md,
        AppSpacing.screenMargin,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          BookHero(book: book),
          const SizedBox(height: AppSpacing.lg),
          LibraryActions(
            isSaved: saved != null,
            enabled: !_store.isSaving,
            onAdd: _store.add,
            onRemove: () => _remove(book),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (saved != null) ...[
            DetailsSection(
              label: 'Status de leitura',
              child: ReadingStatusSelector(
                selected: saved.status,
                enabled: !_store.isSaving,
                onChanged: _store.changeStatus,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          DetailsSection(
            label: 'Sinopse',
            child: Text(
              description == null || description.trim().isEmpty
                  ? 'Sem sinopse disponível.'
                  : description,
              style: textTheme.bodyLarge?.copyWith(
                color: description == null ? AppColors.textMuted : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
