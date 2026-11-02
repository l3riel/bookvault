import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../models/reading_status.dart';
import '../../../stores/library_store.dart';

/// Chips de filtro roláveis: Todos, Quero ler, Lendo, Concluídos.
class LibraryFilterBar extends StatelessWidget {
  const LibraryFilterBar({required this.store, super.key});

  final LibraryStore store;

  static String labelOf(ReadingStatus? status) => switch (status) {
    null => 'Todos',
    ReadingStatus.wantToRead => 'Quero ler',
    ReadingStatus.reading => 'Lendo',
    ReadingStatus.completed => 'Concluídos',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.touchTarget,
      child: Observer(
        builder: (context) {
          final options = <ReadingStatus?>[null, ...ReadingStatus.values];
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
            ),
            itemCount: options.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final status = options[index];
              final count = status == null
                  ? store.total
                  : store.countByStatus[status]!;
              final selected = store.filter == status;
              return Center(
                child: ChoiceChip(
                  label: Text('${labelOf(status)} ($count)'),
                  selected: selected,
                  onSelected: (_) => store.setFilter(status),
                  labelStyle: AppTypography.labelLarge.copyWith(
                    color: selected ? AppColors.brass : AppColors.textMuted,
                  ),
                  side: BorderSide(
                    color: selected
                        ? AppColors.brass.withValues(alpha: 0.6)
                        : AppColors.borderSubtle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
