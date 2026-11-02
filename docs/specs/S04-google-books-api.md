# Spec — Integração com a Google Books API (Etapa 04)

- **ID:** Etapa 04 do [Plano de Execução](../PLANO.md) (base de F3, F4 e F5 do `docs/PRD.md`)
- **Status:** rascunho
- **Pastas:** `lib/services/`, `lib/data/dtos/`, `lib/data/repositories/`, `lib/app/app_dependencies.dart`

## Objetivo
Buscar livros por título ou autor e consultar os detalhes de um livro na Google Books API, entregando ao resto do app só modelos `Book` e erros já traduzidos.

## Histórias de usuário
- Como usuário, quero digitar um título ou autor e ver os livros correspondentes.
- Como usuário, quero abrir um livro e ver seus detalhes, mesmo que a API não traga todos os campos.
- Como usuário, quero uma mensagem clara quando estiver sem internet ou a busca falhar.

## Regras de negócio
1. **Camadas:** `BooksApiService` (`services/books_api_service.dart`) faz as chamadas HTTP com o Dio e devolve DTOs. `BooksRepository` (`data/repositories/books_repository.dart`) chama o serviço, converte DTO → `Book` e traduz erros. Telas e Stores só falam com o repositório.
2. **Busca:** um campo único (como no protótipo, "livros, autores…") enviado em `q`; a API procura em título e autor. Endpoint `GET volumes?q=<termo>&printType=books&maxResults=20`.
3. Termo vazio ou só com espaços devolve lista vazia **sem** chamar a API.
4. **Detalhes:** `GET volumes/<volumeId>`.
5. **DTO:** `GoogleBooksVolumeDto` (`data/dtos/google_books_volume_dto.dart`) espelha o JSON da API (`id`, `volumeInfo.title`, `authors`, `description`, `imageLinks.thumbnail`/`smallThumbnail`, `publisher`, `publishedDate`, `pageCount`, `categories`) e tem `toBook()`. O DTO nunca sai de `data/`.
6. **Campos ausentes:** viram `null`/lista vazia no `Book`. Volume sem `id` ou sem título é descartado da busca (e, nos detalhes, vira erro de "livro não encontrado").
7. **Capa:** usa `thumbnail`, ou `smallThumbnail` se faltar; `http://` é trocado por `https://` (o Android bloqueia HTTP sem TLS).
8. **Descrição:** a API às vezes manda HTML simples (`<p>`, `<br>`, `<b>`); as tags são removidas na conversão.
9. **Erros:** o repositório lança `BooksException` (`data/repositories/books_exception.dart`) com um tipo:
   - `noConnection`: sem internet / falha de conexão;
   - `timeout`: tempo esgotado;
   - `notFound`: volume inexistente (HTTP 404) ou sem dados mínimos;
   - `server`: qualquer outra resposta de erro (4xx/5xx) ou JSON inesperado.
   Cada tipo tem uma mensagem pt-BR para a interface (ex.: "Sem conexão com a internet.").
10. Sem chave de API (ADR 0004).
11. `AppDependencies` passa a criar o `BooksApiService` e o `BooksRepository`.

## Interface
Nenhuma tela nesta etapa.

## Dados
```text
BooksApiService
  Future<List<GoogleBooksVolumeDto>> searchVolumes(String query)
  Future<GoogleBooksVolumeDto> getVolume(String volumeId)

BooksRepository
  Future<List<Book>> search(String query)
  Future<Book> getById(String volumeId)

BooksException implements Exception
  BooksErrorType type   (noConnection | timeout | notFound | server)
  String message        (pt-BR)
```

## Critérios de aceite (viram testes, sem rede real: o Dio usa um adaptador falso)
- [ ] Dada uma resposta com dois volumes, quando busco "duna", então recebo dois `Book` com id, título, autores e capa convertidos.
- [ ] Dada uma busca, então a requisição vai para `volumes` com `q=<termo>`, `printType=books` e `maxResults=20`.
- [ ] Dada uma resposta sem `items` (`totalItems: 0`), quando busco, então recebo lista vazia.
- [ ] Dado um termo vazio ou só com espaços, quando busco, então recebo lista vazia e nenhuma requisição é feita.
- [ ] Dado um volume sem descrição, editora, páginas e capa, quando converto, então esses campos ficam `null` e nada quebra.
- [ ] Dado um volume sem título na busca, então ele é descartado e os demais aparecem.
- [ ] Dada uma capa com `http://`, quando converto, então ela vira `https://`; sem `thumbnail`, usa `smallThumbnail`.
- [ ] Dada uma descrição com `<p>` e `<br>`, quando converto, então o texto vem sem tags.
- [ ] Dado um id existente, quando consulto detalhes, então recebo o `Book` com editora, data e páginas.
- [ ] Dado um HTTP 404 nos detalhes, então é lançado `BooksException` do tipo `notFound`.
- [ ] Dada falha de conexão, tempo esgotado ou HTTP 500, então é lançado `BooksException` com o tipo correspondente.

## Fora de escopo desta spec
Telas de Explorar, Detalhes e Início (Etapas 07 e 08), recomendação por gênero (Etapa 08), paginação/rolagem infinita, cache das buscas.

## Pendências para aprovar
1. **Idioma dos resultados:** proposta: **sem filtro** (a Google decide; títulos famosos aparecem em várias línguas). Alternativa: `langRestrict=pt`, só livros em português (menos resultados).
2. **Quantidade:** proposta: **20 resultados** por busca, sem paginação no MVP. Alternativa: até 40 (máximo da API).
