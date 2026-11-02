# Spec — Modelos e estruturas de dados (Etapa 02)

- **ID:** Etapa 02 do [Plano de Execução](../PLANO.md) (base de F1–F5 do `docs/PRD.md`)
- **Status:** rascunho
- **Pastas:** `lib/models/`, `test/models/`

## Objetivo
Ter os modelos internos do app, com conversão para JSON, prontos para a persistência (Etapa 03) e para a conversão da Google Books (Etapa 04).

## Histórias de usuário
- Como desenvolvedor, quero modelos únicos e independentes da API para que telas, Stores e repositórios falem a mesma língua.
- Como usuário, quero que meus livros salvos guardem título, capa e autores para vê-los mesmo sem internet.

## Regras de negócio
1. Os modelos ficam em `lib/models/`, em Dart puro: sem `package:flutter`, sem Dio e sem DTO.
2. O identificador do livro é o `volumeId` do Google Books (`Book.id`).
3. `UserBook` guarda um **snapshot** completo do `Book` (não só o id), o status de leitura e a data de inclusão.
4. A biblioteca considera dois `UserBook` o mesmo livro quando têm o mesmo `book.id` (a unicidade em si é garantida na Etapa 03).
5. O JSON destes modelos é o formato **interno** de persistência. O formato da Google Books é outro e fica no DTO da Etapa 04.
6. Campos opcionais ausentes no JSON viram `null` (ou lista vazia, nas listas), sem lançar erro.
7. Datas são gravadas em ISO 8601 (`DateTime.toIso8601String()`).
8. Modelos são imutáveis (`final` + construtor `const` quando possível); mudanças geram cópia via `copyWith`.
9. Igualdade por valor (`==` e `hashCode` escritos à mão, sem pacote).

## Interface
Nenhuma tela nesta etapa.

## Dados
```text
ReadingStatus (enum)
  wantToRead  → JSON 'want_to_read' · rótulo 'Quero ler'
  reading     → JSON 'reading'      · rótulo 'Lendo'
  completed   → JSON 'completed'    · rótulo 'Lido'

Book
  id            String        obrigatório (volumeId)
  title         String        obrigatório
  authors       List<String>  vazio se ausente
  description   String?
  thumbnailUrl  String?
  publisher     String?
  publishedDate String?       texto como vem da API ('2004', '2004-05', '2004-05-12')
  pageCount     int?
  categories    List<String>  vazio se ausente

UserBook
  book     Book           snapshot
  status   ReadingStatus
  addedAt  DateTime

UserPreferences
  name    String
  genres  List<String>   um ou mais gêneros escolhidos no onboarding
```

## Critérios de aceite (viram testes)
- [ ] Dado um `Book` completo, quando faço `toJson` e depois `fromJson`, então obtenho um `Book` igual ao original.
- [ ] Dado um JSON de `Book` só com `id` e `title`, quando faço `fromJson`, então os opcionais são `null` e as listas vêm vazias.
- [ ] Dado um JSON de `Book` sem `id` ou sem `title`, quando faço `fromJson`, então é lançado `FormatException`.
- [ ] Dado cada `ReadingStatus`, quando converto para JSON e de volta, então obtenho o mesmo valor; e cada um tem o rótulo pt-BR da tabela.
- [ ] Dado um `UserBook`, quando faço `toJson`/`fromJson`, então o snapshot do livro, o status e `addedAt` são preservados.
- [ ] Dado um `UserBook`, quando chamo `copyWith(status: ReadingStatus.reading)`, então só o status muda.
- [ ] Dado um `UserPreferences`, quando faço `toJson`/`fromJson`, então nome e gêneros são preservados.
- [ ] Nenhum arquivo de `lib/models/` importa `package:flutter` (teste que lê os imports).

## Fora de escopo desta spec
Persistência (Etapa 03), DTO e conversão da Google Books (Etapa 04), lista de gêneros do onboarding (Etapa 05).

## Pendências para aprovar
1. **Status desconhecido no JSON** (ex.: dado corrompido): lançar `FormatException` (proposta) ou cair em `Quero ler`?
2. **Rótulo de `completed`:** "Lido" (proposta; o filtro da biblioteca diz "Lidos") ou "Concluído"?
3. **Gêneros** em `UserPreferences`: texto livre (proposta; a lista fixa vem na Etapa 05) ou enum já agora?
