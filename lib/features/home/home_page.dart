import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/widgets/brand_app_bar.dart';
import '../../app/widgets/state_message.dart';
import '../../models/book.dart';
import '../../stores/home_store.dart';
import '../../stores/library_store.dart';
import 'widgets/genre_shelf_row.dart';
import 'widgets/home_header.dart';
import 'widgets/home_section_header.dart';
import 'widgets/spotlight_card.dart';

/// Aba Início: saudação e recomendações pelos gêneros (S08).
///
/// Carrega uma vez: a aba fica viva ao trocar de aba; puxar para baixo
/// recarrega.
class HomePage extends StatefulWidget {
  const HomePage({
    required this.createStore,
    required this.libraryStore,
    super.key,
  });

  final HomeStore Function() createStore;
  final LibraryStore libraryStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore _store = widget.createStore()..load();

  LibraryStore get _library => widget.libraryStore;

  void _openDetails(Book book) {
    context.push(AppRoutes.bookDetailsOf(book.id), extra: book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(),
      body: RefreshIndicator(
        onRefresh: _store.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.sm,
                AppSpacing.screenMargin,
                AppSpacing.lg,
              ),
              child: HomeHeader(
                greeting: _store.greeting,
                onSearchTap: () => context.go(AppRoutes.explore),
              ),
            ),
            Observer(builder: (context) => _recommendations()),
          ],
        ),
      ),
    );
  }

  Widget _recommendations() {
    switch (_store.status) {
      case HomeStatus.loading:
        return const Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        );
      case HomeStatus.error:
        return Center(
          child: StateMessage(
            scrollable: false,
            icon: Icons.cloud_off_outlined,
            title: 'Não foi possível carregar as recomendações',
            message: _store.errorMessage ?? '',
            actionLabel: 'Tentar de novo',
            onAction: _store.load,
          ),
        );
      case HomeStatus.empty:
        return Center(
          child: StateMessage(
            scrollable: false,
            icon: Icons.auto_stories_outlined,
            title: 'Nenhuma recomendação agora',
            message: 'Encontre livros por título ou autor.',
            actionLabel: 'Explorar livros',
            actionIcon: Icons.explore_outlined,
            onAction: () => context.go(AppRoutes.explore),
          ),
        );
      case HomeStatus.ready:
        return _ready();
    }
  }

  Widget _ready() {
    final spotlight = _store.spotlight!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeSectionHeader(
                title: 'Destaque para você',
                icon: Icons.auto_awesome,
              ),
              const SizedBox(height: AppSpacing.sm),
              SpotlightCard(
                book: spotlight,
                isSaved: _library.savedBook(spotlight.id) != null,
                onOpen: () => _openDetails(spotlight),
                onSave: () => _library.add(spotlight),
              ),
            ],
          ),
        ),
        for (final shelf in _store.shelves) ...[
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
            ),
            child: HomeSectionHeader(
              title: shelf.genre.label,
              onSeeAll: () =>
                  context.go(AppRoutes.exploreSearch(shelf.genre.label)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GenreShelfRow(
            books: shelf.books,
            statusOf: (book) => _library.savedBook(book.id)?.status,
            onBookTap: _openDetails,
          ),
        ],
      ],
    );
  }
}
