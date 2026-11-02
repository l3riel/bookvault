# Arquitetura — BookVault

## Stack
- **Flutter** (stable) + **Dart 3**, alvos: Android e Web.
- Qualidade: `flutter analyze` (regras estritas em `analysis_options.yaml`) e `flutter test`, rodados no CI a cada push.

## Organização
Feature-first, com três camadas por feature. Detalhes e árvore de pastas em [`lib/README.md`](../lib/README.md).

| Camada | Responsabilidade | Pode depender de |
|---|---|---|
| `domain` | Entidades e regras de negócio, Dart puro | nada |
| `data` | Persistência, APIs, conversão de modelos | `domain` |
| `presentation` | Telas, widgets, estado de UI | `domain` |

## Decisões em aberto (o arquiteto decide e registra em `docs/adr/`)
| Tema | Opções comuns | ADR |
|---|---|---|
| Gerência de estado | `setState`/`ValueNotifier`, Provider, Riverpod, Bloc | — |
| Persistência local | `shared_preferences`, Hive/Isar, sqflite/Drift | — |
| Fonte de dados de livros | cadastro manual, Google Books API, Open Library API | — |
| Navegação | `Navigator` nativo, `go_router` | — |

Enquanto uma decisão estiver em aberto, a IA **não** adiciona pacote para ela: pergunta ou usa o recurso nativo do Flutter.

## Registro de decisões
Ver [`docs/adr/`](adr/).
