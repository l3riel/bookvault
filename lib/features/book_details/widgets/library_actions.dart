import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

/// Fora da biblioteca: "Adicionar à biblioteca". Salvo: o selo
/// "Na sua biblioteca" e "Remover da biblioteca".
class LibraryActions extends StatelessWidget {
  const LibraryActions({
    required this.isSaved,
    required this.enabled,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final bool isSaved;
  final bool enabled;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (!isSaved) {
      return SizedBox(
        width: double.infinity,
        height: AppSpacing.touchTarget,
        child: FilledButton.icon(
          onPressed: enabled ? onAdd : null,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar à biblioteca'),
        ),
      );
    }
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: AppSpacing.touchTarget,
          decoration: BoxDecoration(
            color: AppColors.brass,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check, size: 20, color: AppColors.onBrass),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Na sua biblioteca',
                style: textTheme.labelLarge?.copyWith(color: AppColors.onBrass),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton.icon(
          onPressed: enabled ? onRemove : null,
          style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Remover da biblioteca'),
        ),
      ],
    );
  }
}
