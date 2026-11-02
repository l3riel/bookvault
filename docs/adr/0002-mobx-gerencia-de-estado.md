# ADR 0002 — MobX para gerência de estado

- **Data:** 2026-11-02
- **Status:** aceita (decisão do arquiteto no [Plano de Execução](../PLANO.md))

## Contexto
As telas precisam reagir a dados assíncronos (busca, recomendações) e a mudanças na biblioteca local. O ARCHITECTURE.md deixava a gerência de estado em aberto.

## Decisão
Usar MobX (`mobx`, `flutter_mobx`) com geração de código (`mobx_codegen` + `build_runner`, só em dev). Cada feature tem sua Store (`OnboardingStore`, `HomeStore`, `SearchStore`, `LibraryStore`) na camada `presentation`, e os widgets observam com `Observer`.

## Alternativas consideradas
- `setState`/`ValueNotifier`: simples, mas espalha lógica nos widgets quando várias telas compartilham a biblioteca.
- Provider/Riverpod/Bloc: igualmente válidos; o arquiteto escolheu MobX.

## Consequências
- Arquivos `*.g.dart` gerados: rodar `dart run build_runner build --delete-conflicting-outputs` após mudar uma Store. Os gerados são versionados para o CI não precisar gerar.
- Stores dependem de repositórios injetados pelo construtor (injeção manual), o que facilita testes.
