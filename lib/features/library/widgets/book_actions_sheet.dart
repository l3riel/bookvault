import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../models/reading_status.dart';
import '../../../models/user_book.dart';

/// Escolha feita na folha de ações de um livro.
sealed class BookAction {
  const BookAction();
}

class ChangeStatusAction extends BookAction {
  const ChangeStatusAction(this.status);

  final ReadingStatus status;
}

class RemoveBookAction extends BookAction {
  const RemoveBookAction();
}

/// Abre a folha inferior com os status e "Remover da biblioteca".
/// Devolve `null` se o usuário fechar sem escolher.
Future<BookAction?> showBookActionsSheet(
  BuildContext context,
  UserBook userBook,
) {
  return showModalBottomSheet<BookAction>(
    context: context,
    backgroundColor: AppColors.surfaceElevated,
    showDragHandle: true,
    builder: (context) => _BookActionsSheet(userBook: userBook),
  );
}

class _BookActionsSheet extends StatelessWidget {
  const _BookActionsSheet({required this.userBook});

  final UserBook userBook;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(
              userBook.book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineSmall,
            ),
          ),
          for (final status in ReadingStatus.values)
            ListTile(
              leading: Icon(
                status == userBook.status
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: status == userBook.status
                    ? AppColors.brass
                    : AppColors.textMuted,
              ),
              title: Text(status.label),
              onTap: () => Navigator.pop(context, ChangeStatusAction(status)),
            ),
          const Divider(height: AppSpacing.md),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.error),
            title: Text(
              'Remover da biblioteca',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
            onTap: () => Navigator.pop(context, const RemoveBookAction()),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
