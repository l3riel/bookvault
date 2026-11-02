# Spec — Preparação do projeto (Etapa 01)

- **ID:** F0 (ver tabela do `docs/PRD.md`)
- **Status:** aprovada
- **Feature folder:** `lib/app/`, `lib/core/`, esqueleto de `lib/features/`

## Objetivo
Deixar o app pronto para receber as features: dependências instaladas, tema Nocturne Editorial aplicado, navegação entre as três abas funcionando e dependências injetadas manualmente.

## Histórias de usuário
- Como desenvolvedor, quero tema, rotas e injeção de dependências prontos para implementar cada feature sem mexer na infraestrutura.
- Como usuário, quero abrir o app e alternar entre Home, Explore e Library pela barra inferior.

## Regras de negócio
1. Dependências: `mobx`, `flutter_mobx`, `dio`, `go_router`, `shared_preferences`; dev: `mobx_codegen`, `build_runner` (ADRs 0002–0005). `cupertino_icons` sai (não usado).
2. Fontes Newsreader e DM Sans em `assets/fonts/` (ADR 0006).
3. Tema escuro único, com tokens do `DESIGN.md` em `AppColors`, `AppTypography`, `AppSpacing` e `AppRadius`; nenhum widget usa cor ou tamanho literal.
4. Rotas: `/onboarding`, `/home`, `/explore`, `/library` (abas com `StatefulShellRoute`) e `/book/:id`.
5. Nesta etapa, o redirect para o onboarding fica pronto mas recebe a informação de "já fez onboarding" por parâmetro (a persistência real chega na Etapa 03/05); por padrão o app abre na Home.
6. Telas são placeholders (título da tela centralizado); o conteúdo vem nas etapas seguintes.
7. `main.dart` cria `SharedPreferences`, `Dio` e os objetos compartilhados e os passa pelo construtor; sem service locator.

## Interface
- Barra inferior conforme o protótipo: 64px, fundo `#161619` com borda superior `#2E2E36`, ícones `auto_stories` (Início), `explore` (Explorar) e `local_library` (Biblioteca); aba ativa em brass `#D4AF37`.
- Referência: `design/home.png`.

## Dados
Nenhum modelo nesta etapa.

## Critérios de aceite (viram testes)
- [ ] Dado o app iniciado, quando a primeira tela aparece, então ela é a Home e a barra mostra as abas Início, Explorar e Biblioteca.
- [ ] Dado o app na Home, quando toco em Explorar e depois em Biblioteca, então a tela correspondente aparece e a aba fica ativa.
- [ ] Dado um usuário sem onboarding, quando o app inicia, então o redirect leva a `/onboarding`.
- [ ] Dado o tema do app, então `scaffoldBackgroundColor` é `#121214` e a cor primária é `#D4AF37`.
- [ ] `dart format .`, `flutter analyze` e `flutter test` passam; o app roda no emulador e no Chrome.

## Fora de escopo desta spec
Modelos, persistência, API, conteúdo real das telas.

## Decisões do arquiteto
- Textos da interface em pt-BR: abas "Início", "Explorar" e "Biblioteca".
- ADR 0006 aceita: fontes empacotadas em `assets/fonts/`.
