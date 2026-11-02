import 'package:flutter/material.dart';

import '../../models/reading_status.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Selo de status de leitura, como no protótipo: "Lendo" em brass, os
/// demais em fundo escuro com ícone.
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final ReadingStatus status;

  @override
  Widget build(BuildContext context) {
    final reading = status == ReadingStatus.reading;
    final foreground = switch (status) {
      ReadingStatus.reading => AppColors.onBrass,
      ReadingStatus.wantToRead => AppColors.textParchment,
      ReadingStatus.completed => AppColors.sage,
    };
    final icon = switch (status) {
      ReadingStatus.reading => Icons.circle,
      ReadingStatus.wantToRead => Icons.bookmark_border,
      ReadingStatus.completed => Icons.check_circle,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: reading
            ? AppColors.brass
            : AppColors.surfaceBase.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: reading ? 6 : 12, color: foreground),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              status.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
