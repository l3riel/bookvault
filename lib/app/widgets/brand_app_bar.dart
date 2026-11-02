import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Barra do topo das abas: logo + "BookVault" e lupa que abre Explorar.
class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandAppBar({this.showSearch = true, super.key});

  final bool showSearch;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: AppSpacing.screenMargin,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.local_library,
              size: 18,
              color: AppColors.brass,
            ),
          ),
          const SizedBox(width: AppSpacing.gutter),
          const Flexible(child: Text('BookVault')),
        ],
      ),
      actions: [
        if (showSearch)
          IconButton(
            tooltip: 'Buscar livros',
            icon: const Icon(Icons.search),
            onPressed: () => context.go(AppRoutes.explore),
          ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
