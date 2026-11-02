import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

/// Botão "Começar": desabilitado se [onPressed] for nulo; mostra carregando
/// enquanto [loading].
class StartButton extends StatelessWidget {
  const StartButton({
    required this.onPressed,
    required this.loading,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: loading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.onBrass,
              ),
            )
          : const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Começar'),
                SizedBox(width: AppSpacing.sm),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
    );
  }
}
