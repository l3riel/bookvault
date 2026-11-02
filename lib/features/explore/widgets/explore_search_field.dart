import 'package:flutter/material.dart';

/// Campo de busca do Explorar. Busca ao confirmar pelo teclado; o ✕ limpa.
class ExploreSearchField extends StatelessWidget {
  const ExploreSearchField({
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: 'Buscar por título ou autor',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Limpar busca',
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
        ),
      ),
    );
  }
}
