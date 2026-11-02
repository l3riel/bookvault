import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../stores/onboarding_store.dart';
import 'widgets/genre_selector.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/section_title.dart';
import 'widgets/start_button.dart';

/// Primeiro acesso: nome e gêneros favoritos (S05).
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.createStore, super.key});

  /// Cria a Store da tela; chamada uma vez, quando a tela abre.
  final OnboardingStore Function() createStore;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final OnboardingStore _store = widget.createStore();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final saved = await _store.submit();
    if (saved && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.xl,
            AppSpacing.screenMargin,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const OnboardingHeader(),
              const SizedBox(height: AppSpacing.xl),
              const SectionTitle(
                title: 'Como devemos te chamar?',
                subtitle: 'Usado para personalizar suas recomendações.',
              ),
              const SizedBox(height: AppSpacing.gutter),
              TextField(
                controller: _nameController,
                onChanged: _store.setName,
                maxLength: maxNameLength,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                style: textTheme.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Seu nome',
                  counterText: '',
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              GenreSelector(store: _store),
              const SizedBox(height: AppSpacing.xl),
              Observer(
                builder: (_) => StartButton(
                  onPressed: _store.canSubmit ? _submit : null,
                  loading: _store.isSaving,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: AppColors.brass,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      'Salvo apenas neste aparelho',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
