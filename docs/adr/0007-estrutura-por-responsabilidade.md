# ADR 0007 — Estrutura de pastas do Plano de Execução

- **Data:** 2026-11-02
- **Status:** aceita (decisão do arquiteto) · substitui a [ADR 0001](0001-flutter-feature-first.md)

## Contexto
A Etapa 01 foi implementada com o feature-first da ADR 0001, mapeando nele as pastas do [Plano de Execução](../PLANO.md). O arquiteto pediu que o código siga fielmente a árvore do plano.

## Decisão
Organizar `lib/` por responsabilidade, exatamente como no plano:

- `app/`: `app.dart`, `router.dart` e `theme/` (cores, tipografia, espaçamento, tema).
- `core/`: infraestrutura (`network/dio_client.dart`, `storage/local_storage.dart`).
- `models/`: modelos internos (`Book`, `UserBook`, `UserPreferences`, `ReadingStatus`), Dart puro.
- `data/`: `dtos/` da API e `repositories/`.
- `services/`: acesso à API externa (`BooksApiService`).
- `stores/`: Stores MobX, uma por área.
- `features/<tela>/`: telas e componentes específicos de cada tela.

## Alternativas consideradas
- Manter o feature-first da ADR 0001 com o mapeamento: preservava a ADR, mas se afastava do documento que guia o projeto.

## Consequências
- Regras de dependência: `features → stores → data/repositories → (services | core) → models`. Widgets não fazem HTTP nem persistência; `models` não importa Flutter nem DTOs.
- Testes espelham `lib/` (ex.: `test/models/`, `test/data/repositories/`).
- Arquivos de apoio que o plano não lista ficam na pasta mais próxima da responsabilidade: `app/app_shell.dart` (barra de abas), `app/app_dependencies.dart` (injeção manual) e `app/widgets/` (widgets provisórios/compartilhados do app).
