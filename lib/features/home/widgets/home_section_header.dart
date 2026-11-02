import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

/// Título de seção da Home, com ícone opcional e "Ver todos" opcional.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    required this.title,
    this.icon,
    this.onSeeAll,
    super.key,
  });

  final String title;
  final IconData? icon;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final leading = icon;
    final seeAll = onSeeAll;
    return Row(
      children: [
        if (leading != null) ...[
          Icon(leading, size: 20, color: AppColors.brass),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (seeAll != null)
          TextButton(
            onPressed: seeAll,
            style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
            child: Text('Ver todos', semanticsLabel: 'Ver todos de $title'),
          ),
      ],
    );
  }
}
