import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/widgets/brand_app_bar.dart';
import '../../app/widgets/state_message.dart';
import '../../models/book.dart';
import '../../models/genre.dart';
import '../../stores/explore_store.dart';
import '../../stores/library_store.dart';
import 'widgets/explore_intro.dart';
import 'widgets/explore_search_field.dart';
import 'widgets/search_result_card.dart';

/// Aba Explorar: busca na Google Books e resultados em grade (S07).
class ExplorePage extends StatefulWidget {
  const ExplorePage({
    required this.createStore,
    required this.libraryStore,
    this.initialQuery,
    super.key,
  });

  /// Termo vindo da rota (`/explore?q=`): busca assim que chega.
  final String? initialQuery;

  final ExploreStore Function() createStore;
  final LibraryStore libraryStore;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final ExploreStore _store = widget.createStore();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFromRoute(widget.initialQuery);
  }

  @override
  void didUpdateWidget(ExplorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery) {
      _searchFromRoute(widget.initialQuery);
    }
  }

  void _searchFromRoute(String? query) {
    if (query == null || query.trim().isEmpty) return;
    _controller.text = query;
    _store.search(query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    FocusScope.of(context).unfocus();
    _store.search(query);
  }

  void _searchGenre(Genre genre) {
    _controller.text = genre.label;
    _search(genre.label);
  }

  void _clear() {
    _controller.clear();
    _store.clear();
  }

  void _openDetails(Book book) {
    context.push(AppRoutes.bookDetailsOf(book.id), extra: book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(showSearch: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenMargin,
              AppSpacing.sm,
              AppSpacing.screenMargin,
              AppSpacing.sm,
            ),
            child: ExploreSearchField(
              controller: _controller,
              onSubmitted: _search,
              onClear: _clear,
            ),
          ),
          Expanded(child: Observer(builder: (context) => _body())),
        ],
      ),
    );
  }

  Widget _body() {
    switch (_store.status) {
      case ExploreStatus.initial:
        return ExploreIntro(
          genres: _store.suggestions,
          onGenreTap: _searchGenre,
        );
      case ExploreStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ExploreStatus.empty:
        return StateMessage(
          icon: Icons.search_off,
          title: 'Nada encontrado',
          message:
              'Nenhum livro corresponde a "${_store.searchedTerm}". '
              'Tente outro título ou autor.',
        );
      case ExploreStatus.error:
        return StateMessage(
          icon: Icons.cloud_off_outlined,
          title: 'Algo deu errado',
          message: _store.errorMessage ?? '',
          actionLabel: 'Tentar de novo',
          onAction: _store.retry,
        );
      case ExploreStatus.success:
        return _results();
    }
  }

  Widget _results() {
    final textTheme = Theme.of(context).textTheme;
    final count = _store.resultCount;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              count == 1 ? '1 resultado' : '$count resultados',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.gutter,
              childAspectRatio: 0.55,
            ),
            itemCount: count,
            itemBuilder: (context, index) {
              final book = _store.results[index];
              return SearchResultCard(
                book: book,
                savedStatus: widget.libraryStore.savedBook(book.id)?.status,
                onTap: () => _openDetails(book),
              );
            },
          ),
        ),
      ],
    );
  }
}
