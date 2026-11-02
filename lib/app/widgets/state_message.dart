import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Aviso centralizado de estado da tela (sem resultados, erro).
class StateMessage extends StatelessWidget {
  const StateMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon = Icons.refresh,
    this.scrollable = true,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData actionIcon;

  /// `false` quando já está dentro de uma lista que rola.
  final bool scrollable;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final label = actionLabel;
    const padding = EdgeInsets.all(AppSpacing.xl);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 56, color: AppColors.textMuted),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
        if (label != null) ...[
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: onAction,
            icon: Icon(actionIcon),
            label: Text(label),
          ),
        ],
      ],
    );
    if (!scrollable) return Padding(padding: padding, child: content);
    return Center(
      child: SingleChildScrollView(padding: padding, child: content),
    );
  }
}
