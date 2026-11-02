# Spec — Biblioteca pessoal (Etapa 06)

- **ID:** F2 do `docs/PRD.md` · Etapa 06 do [Plano de Execução](../PLANO.md)
- **Status:** aprovada
- **Pastas:** `lib/features/library/`, `lib/stores/library_store.dart`, `lib/app/widgets/`, `lib/app/app_dependencies.dart`
- **Referência visual:** [`design/library.png`](../../design/library.png)

## Objetivo
O usuário vê os livros que salvou, filtra por status, muda o status e remove livros, tudo offline.

## Histórias de usuário
- Como leitor, quero ver minha estante e filtrar o que quero ler, o que estou lendo e o que já concluí.
- Como leitor, quero mudar o status de um livro ou tirá-lo da biblioteca.

## Regras de negócio
1. **Estado:** `LibraryStore` (MobX) com a lista de `UserBook`, o filtro ativo (`null` = Todos), a lista filtrada e a contagem por status. Ações: `load`, `setFilter`, `changeStatus`, `remove`. Usa só o `LibraryRepository`.
2. A `LibraryStore` é **única no app** (criada no `AppDependencies`), para que livros adicionados nos Detalhes (Etapa 07) apareçam na Biblioteca sem recarregar.
3. Ordem: do mais recente para o mais antigo (já vem assim do repositório).
4. **Filtros:** Todos, Quero ler, Lendo, Concluídos, cada um com a contagem entre parênteses. Como no protótipo, o filtro **apaga** (deixa esmaecidos) os livros de outros status, sem escondê-los; eles continuam tocáveis.
5. Mudar status e remover gravam no aparelho e atualizam a tela na hora.
6. Tocar num livro abre os Detalhes (`/book/<id>`).
7. **Capas:** carregadas da internet; sem conexão (ou sem capa), aparece um marcador com o título, sem quebrar o layout. Guardar as imagens offline fica fora do MVP (exigiria pacote novo).
8. Componentes reutilizáveis pelas próximas telas ficam em `lib/app/widgets/`: `BookCover` (capa com marcador) e `StatusBadge` (selo de status).

## Interface
Fiel ao protótipo, com textos em pt-BR:

| Protótipo | No app |
|---|---|
| Barra: logo + BookVault + 🔍 | igual; a lupa abre a aba Explorar |
| My Library | Minha biblioteca |
| 6 books in library | 6 livros na biblioteca (1 livro na biblioteca) |
| All (6) · Want to Read (2) · Reading (2) · Completed (2) | Todos (6) · Quero ler (2) · Lendo (2) · Concluídos (2), em chips roláveis na horizontal |
| Grade de 2 colunas: capa com selo de status, título (Newsreader) e autor (cinza) | igual |

- **Vazio (sem livros):** ícone, "Sua biblioteca está vazia", "Encontre livros em Explorar e salve aqui." e botão "Explorar livros".
- **Filtro sem livros:** aviso "Nenhum livro em <status>." acima da grade (os demais aparecem apagados).
- **Mudar status / remover:** segurar o dedo no livro ou tocar no ⋮ do card abre uma folha inferior com os três status (o atual marcado) e "Remover da biblioteca"; remover pede confirmação.

## Dados
Sem modelo novo. Usa `UserBook`, `ReadingStatus` e o `LibraryRepository`.

## Critérios de aceite (viram testes)
- [ ] Dada uma biblioteca com livros salvos, quando abro a aba Biblioteca (mesmo sem internet), então vejo os livros com título, autor e selo de status.
- [ ] Dada uma biblioteca vazia, então vejo o estado vazio e o botão "Explorar livros" leva à aba Explorar.
- [ ] Dados livros em status diferentes, quando escolho o filtro "Lendo", então os livros em leitura ficam em destaque e os demais apagados, e os chips mostram as contagens certas.
- [ ] Dado um livro "Quero ler", quando mudo o status para "Concluído" pela folha inferior, então o selo muda na hora e a mudança persiste ao reabrir.
- [ ] Dado um livro na biblioteca, quando o removo e confirmo, então ele some na hora e não volta ao reabrir.
- [ ] Dado um livro na biblioteca, quando toco nele, então abrem os Detalhes desse livro.
- [ ] Dado um livro sem capa, então aparece o marcador com o título.

## Fora de escopo desta spec
Adicionar livros (vem pelos Detalhes, Etapa 07), busca dentro da biblioteca, ordenação diferente, cache de capas.

## Decisões do arquiteto
1. Mudar status e remover por folha inferior (segurar o livro ou tocar no ⋮), com confirmação para remover.
2. O filtro apaga os livros de outros status, como no protótipo, em vez de escondê-los.
