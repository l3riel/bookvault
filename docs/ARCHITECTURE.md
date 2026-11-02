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
Por responsabilidade, fiel ao [Plano de Execução](PLANO.md) ([ADR 0007](adr/0007-estrutura-por-responsabilidade.md), que substitui a ADR 0001). Árvore de pastas em [`lib/README.md`](../lib/README.md).

| Pasta | Responsabilidade | Pode depender de |
|---|---|---|
| `models/` | Modelos internos, Dart puro | nada |
| `services/` | Chamadas HTTP à Google Books (Dio) | `core/network`, `data/dtos` |
| `data/dtos/` | Formato bruto da API | nada |
| `data/repositories/` | Converte DTO → modelo, persiste e lê dados locais | `services`, `core/storage`, `models` |
| `stores/` | Estado MobX das telas | `data/repositories`, `models` |
| `features/<tela>/` | Telas e componentes | `stores`, `models`, `app/theme` |
| `app/` | Raiz do app, rotas, tema, injeção de dependências | tudo |

Fluxo: `Widget → Store → Repository → (BooksApiService | LocalStorage) → DTO → Model`.

## Registro de decisões
Ver [`docs/adr/`](adr/).
