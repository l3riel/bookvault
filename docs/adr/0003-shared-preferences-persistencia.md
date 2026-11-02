# ADR 0003 — SharedPreferences para persistência local

- **Data:** 2026-11-02
- **Status:** aceita (decisão do arquiteto no [Plano de Execução](../PLANO.md))

## Contexto
Biblioteca e preferências precisam funcionar offline. O volume de dados é pequeno (dezenas a centenas de livros de um único usuário).

## Decisão
Usar `shared_preferences`, guardando preferências e biblioteca como JSON. O acesso fica atrás de um `LocalStorage` em `core/storage/`, usado apenas pelos repositórios.

## Alternativas consideradas
- Hive/Isar: mais rápido para grandes volumes, desnecessário aqui.
- sqflite/Drift: consultas relacionais que o MVP não exige, e sem suporte direto na Web.

## Consequências
- Funciona em Android e Web sem configuração extra.
- A biblioteca inteira é lida e regravada a cada mudança; aceitável no volume do MVP.
- Testes usam `SharedPreferences.setMockInitialValues`.
