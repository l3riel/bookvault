import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pede confirmação antes de remover. Devolve `true` se confirmado.
Future<bool> confirmRemoval(BuildContext context, String title) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Remover livro?'),
      content: Text('"$title" vai sair da sua biblioteca.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Remover'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
