# Arquitetura — BookVault

## Stack
- **Flutter** (stable) + **Dart 3**, alvos: Android e Web.
- Estado: **MobX** ([ADR 0002](adr/0002-mobx-gerencia-de-estado.md)).
- Persistência local: **SharedPreferences** ([ADR 0003](adr/0003-shared-preferences-persistencia.md)).
- Livros: **Google Books API** via **Dio** ([ADR 0004](adr/0004-google-books-dio.md)).
- Navegação: **GoRouter** ([ADR 0005](adr/0005-go-router-navegacao.md)).
- Fontes: Newsreader e DM Sans empacotadas ([ADR 0006](adr/0006-fontes-empacotadas.md)).
- Injeção de dependências manual, montada no `main.dart`.
- Qualidade: `flutter analyze` (regras estritas em `analysis_options.yaml`) e `flutter test`, rodados no CI a cada push.

## Organização
Feature-first, com três camadas por feature ([ADR 0001](adr/0001-flutter-feature-first.md)). Detalhes e árvore de pastas em [`lib/README.md`](../lib/README.md).

| Camada | Responsabilidade | Pode depender de |
|---|---|---|
| `domain` | Entidades e regras de negócio, Dart puro | nada |
| `data` | Persistência, APIs, DTOs, conversão de modelos | `domain` |
| `presentation` | Telas, widgets, Stores MobX | `domain` (e repositórios recebidos por injeção) |

Fluxo: `Widget → Store → Repository → (LocalStorage | BooksApiService) → DTO → modelo de domain`.

## Mapeamento do plano
O [Plano de Execução](PLANO.md) lista pastas globais e permite ajustá-las preservando as responsabilidades. Cada item ficou assim:

| Plano | No projeto |
|---|---|
| `app/app.dart`, `app/router.dart` | `lib/app/app.dart`, `lib/core/routing/app_router.dart` |
| `app/theme/*` | `lib/core/theme/` (`app_colors`, `app_typography`, `app_spacing`, `app_theme`) |
| `core/network/dio_client.dart` | `lib/core/network/dio_client.dart` |
| `core/storage/local_storage.dart` | `lib/core/storage/local_storage.dart` |
| `models/book.dart` | `lib/features/books/domain/book.dart` (compartilhado por Explore, Detalhes e Home) |
| `models/user_book.dart`, `reading_status.dart` | `lib/features/library/domain/` |
| `models/user_preferences.dart` | `lib/features/onboarding/domain/` |
| `data/dtos/google_books_volume_dto.dart` | `lib/features/books/data/dtos/` |
| `services/books_api_service.dart` | `lib/features/books/data/books_api_service.dart` |
| `data/repositories/books_repository.dart` | `lib/features/books/data/books_repository.dart` |
| `data/repositories/library_repository.dart` | `lib/features/library/data/library_repository.dart` |
| `stores/<x>_store.dart` | `lib/features/<x>/presentation/<x>_store.dart` |
| `features/<tela>/` | `lib/features/<tela>/presentation/` |

`books` é uma feature só de dados (sem tela própria): reúne o modelo `Book` e o acesso à Google Books API usados por `explore`, `book_details` e `home`.

## Registro de decisões
Ver [`docs/adr/`](adr/).
