import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../models/reading_status.dart';

/// Três abas de status (Quero ler / Lendo / Concluído); a atual em dourado.
class ReadingStatusSelector extends StatelessWidget {
  const ReadingStatusSelector({
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final ReadingStatus selected;
  final ValueChanged<ReadingStatus> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (final status in ReadingStatus.values)
            Expanded(
              child: Semantics(
                selected: status == selected,
                button: true,
                child: Material(
                  color: status == selected
                      ? AppColors.brass
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    onTap: enabled && status != selected
                        ? () => onChanged(status)
                        : null,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: Text(
                        status.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(
                          color: status == selected
                              ? AppColors.onBrass
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
