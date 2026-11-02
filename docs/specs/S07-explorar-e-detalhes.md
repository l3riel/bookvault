# Spec — Explorar e detalhes do livro (Etapa 07)

- **ID:** F3 e F4 do `docs/PRD.md` · Etapa 07 do [Plano de Execução](../PLANO.md)
- **Status:** implementada
- **Pastas:** `lib/features/explore/`, `lib/features/book_details/`, `lib/stores/explore_store.dart`, `lib/stores/book_details_store.dart`, `lib/app/router.dart`, `lib/app/app_dependencies.dart`
- **Referência visual:** [`design/explore.png`](../../design/explore.png), [`design/book_details.png`](../../design/book_details.png)

## Objetivo
O usuário busca livros por título ou autor na Google Books, abre os detalhes de um resultado e o adiciona à biblioteca (ou remove, ou muda o status).

## Histórias de usuário
- Como leitor, quero buscar um livro pelo título ou pelo autor e ver os resultados em grade.
- Como leitor, quero ver os detalhes de um livro e salvá-lo na minha biblioteca com um status.

## Regras de negócio
1. **ExploreStore** (MobX): termo digitado, resultados e estado (`inicial`, `carregando`, `sucesso`, `sem resultados`, `erro`). Usa só o `BooksRepository`. Uma busca nova descarta a resposta de uma busca anterior que chegar atrasada.
2. **Gatilho da busca:** só ao confirmar (tecla "Buscar" do teclado), para poupar a cota da API. Termo em branco não busca.
3. **Erros:** usa as mensagens pt-BR do `BooksException` (sem conexão, tempo esgotado, servidor) e um botão "Tentar de novo" que repete a última busca.
4. Tocar num resultado abre `/book/<id>` levando o `Book` já carregado (sem nova requisição). Se a rota for aberta sem ele (link direto, recarregar na web), os Detalhes buscam pelo id.
5. **BookDetailsStore** (MobX): o livro, o estado de carregamento e o `UserBook` salvo (se houver). Livro salvo na biblioteca abre com os dados locais, **inclusive offline**. Adicionar, mudar status e remover passam pela `LibraryStore` única, então a aba Biblioteca atualiza na hora.
6. **Metadados ausentes:** cada linha (autores, ano, editora, páginas, sinopse) só aparece se o dado existir; sem autor mostra "Autor desconhecido"; sem sinopse mostra "Sem sinopse disponível."; sem capa usa o marcador do `BookCover`.
7. O ano exibido é o começo de `publishedDate` (a API manda "1965", "1965-08" ou "1965-08-01").

## Interface
Fiel aos protótipos, com textos em pt-BR:

| Protótipo (Explore) | No app |
|---|---|
| Campo de busca com 🔍 e ✕ | campo "Buscar por título ou autor"; o ✕ limpa e volta ao estado inicial |
| 6 results found | 6 resultados (1 resultado) |
| Grade de 2 colunas: capa, título, autor | igual (reaproveita `BookCover`); livros já salvos mostram o `StatusBadge` |
| Silence in the Stacks / No matching manuscripts… / Browse All Archives | "Nada encontrado" / "Nenhum livro corresponde a "<termo>". Tente outro título ou autor." (sem botão) |

| Protótipo (Detalhes) | No app |
|---|---|
| ← e título da barra | ← volta; título "Detalhes" |
| Capa grande, título (Newsreader), autor | igual |
| 1965 • Chilton Books • 612 Pages | 1965 • Chilton Books • 612 páginas (só os que existirem) |
| ✓ In Your Vault · Remove from Library | ✓ Na sua biblioteca · Remover da biblioteca (com a mesma confirmação da S06) |
| Reading Status: Want to Read / Reading / Completed | Status de leitura: Quero ler / Lendo / Concluído |
| Synopsis | Sinopse |

- **Explorar, estado inicial:** dica "Busque por título ou autor" e chips com os gêneros escolhidos no onboarding; tocar num chip preenche o campo com o gênero e busca.
- **Carregando:** indicador centralizado (Explorar e Detalhes).
- **Livro fora da biblioteca:** botão "Adicionar à biblioteca" (entra como "Quero ler"). Depois de salvo aparecem "Na sua biblioteca", o seletor de status e "Remover da biblioteca".

## Dados
Sem modelo novo. Usa `Book`, `UserBook`, `ReadingStatus`, `BooksRepository` e a `LibraryStore`. Precisa de uma ação `add(book, status)` na `LibraryStore` (o repositório já tem `add`).

## Critérios de aceite (viram testes)
- [x] Dado que digito "duna" e busco, então vejo a grade com título, autor e capa (ou marcador) e a contagem de resultados.
- [x] Dada uma busca sem resultados, então vejo "Nada encontrado" com o termo buscado.
- [x] Dada uma falha de rede, então vejo a mensagem de erro em pt-BR e "Tentar de novo" repete a busca.
- [x] Dado um resultado, quando toco nele, então abrem os Detalhes desse livro sem nova requisição.
- [x] Dados os Detalhes de um livro sem editora, páginas ou sinopse, então a tela não quebra e omite ou substitui esses campos.
- [x] Dado um livro fora da biblioteca, quando o adiciono, então ele aparece na aba Biblioteca e persiste ao reabrir.
- [x] Dado um livro salvo, então os Detalhes mostram o status atual; quando mudo o status ou removo (confirmando), a Biblioteca reflete na hora.
- [x] Dado um livro salvo e sem internet, quando abro os Detalhes pela Biblioteca, então vejo os dados salvos.

## Fora de escopo desta spec
Paginação ("carregar mais"), filtros na busca, histórico de buscas, recomendações (Etapa 08), chave da API (entra quando o `config/api_keys.json` existir).

## Decisões do arquiteto
1. A busca roda só ao confirmar pelo teclado (poupa a cota da API).
2. Antes de buscar, o Explorar mostra a dica e chips com os gêneros do onboarding.
3. Nos Detalhes, "Adicionar à biblioteca" salva como "Quero ler"; o seletor de status e "Remover" aparecem depois.

## Notas da implementação
- Componentes compartilhados novos em `lib/app/widgets/`: `StateMessage` (aviso de vazio/erro), `confirmRemoval` (movido da Biblioteca) e `authorsLabel`.
- Sem a chave da API, a busca real recebe HTTP 429 (cota anônima esgotada) e mostra o erro de servidor; a chave entra via `config/api_keys.json` + `--dart-define-from-file`.
