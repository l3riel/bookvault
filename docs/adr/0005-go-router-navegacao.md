# ADR 0005 — GoRouter para navegação

- **Data:** 2026-11-02
- **Status:** aceita (decisão do arquiteto no [Plano de Execução](../PLANO.md))

## Contexto
O app tem onboarding condicional (só no primeiro acesso), três abas (Home, Explore, Library) com barra inferior e uma tela de detalhes acessível de todas elas. Na Web, as rotas devem ter URL.

## Decisão
Usar `go_router`, com `StatefulShellRoute` para as abas, `redirect` para mandar ao onboarding quem ainda não tem preferências, e rota `/book/:id` para detalhes.

## Alternativas consideradas
- `Navigator` nativo: exigiria montar à mão o redirect, o estado das abas e as URLs da Web.

## Consequências
- Rotas centralizadas num único arquivo.
- Testes de widget de navegação precisam de `MaterialApp.router`.
