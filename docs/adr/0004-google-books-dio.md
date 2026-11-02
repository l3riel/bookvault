# ADR 0004 — Google Books API via Dio como fonte de livros

- **Data:** 2026-11-02
- **Status:** aceita (decisão do arquiteto no [Plano de Execução](../PLANO.md))

## Contexto
O app precisa buscar livros por título/autor, mostrar detalhes e recomendar por gênero, sem cadastro manual.

## Decisão
Usar a Google Books API (`https://www.googleapis.com/books/v1/volumes`) com o cliente HTTP `dio`. O `volumeId` do Google é o identificador do livro no app. O JSON da API vira `GoogleBooksVolumeDto` e é convertido para o modelo interno `Book`; o DTO não sai da camada `data`.

## Alternativas consideradas
- Open Library API: catálogo menor e metadados menos uniformes.
- Pacote `http`: suficiente, mas o arquiteto escolheu Dio (timeouts, interceptors e erros tipados).

## Consequências
- Busca e recomendações exigem internet; a biblioteca guarda um snapshot dos metadados para funcionar offline.
- Sem chave de API no MVP (cota anônima); se a cota estourar, a chave entra por `--dart-define`, nunca no código.
- Campos ausentes da API precisam ser opcionais no `Book`.
