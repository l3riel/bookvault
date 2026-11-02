# Plano de Execução — BookVault

> **Dono:** Gabriel Arthur (arquiteto) · Fonte: `BookVault_Plano_de_Execucao.pdf`
> Estrutura de trabalho incremental para o MVP mobile. Produto em [`PRD.md`](PRD.md), arquitetura em [`ARCHITECTURE.md`](ARCHITECTURE.md), design em [`DESIGN.md`](../DESIGN.md).

## 1. Princípios
- Implementar somente o escopo do MVP.
- Simplicidade e legibilidade; nada de abstração sem necessidade concreta.
- Separar interface, estado, acesso a dados e serviços externos.
- MobX para gerência de estado.
- Biblioteca e preferências funcionam offline.
- Seguir o design system Nocturne Editorial.
- Validar cada incremento antes de iniciar o próximo.

## 2. Estrutura
O código segue fielmente a árvore do plano ([ADR 0007](adr/0007-estrutura-por-responsabilidade.md)); detalhes em [`lib/README.md`](../lib/README.md).

## 3. Etapas

| # | Etapa | Entregas | Critérios de conclusão | Spec |
|---|---|---|---|---|
| 01 | Preparação | Dependências, tema e tokens, GoRouter, pastas, inicialização e injeção manual de dependências | App executa sem erros; navegação inicial; tema global aplicado | [S01](specs/S01-preparacao.md) |
| 02 | Modelos | `Book`, `UserBook`, `UserPreferences`, `ReadingStatus` com JSON | `volumeId` do Google Books identifica o livro; `UserBook` guarda snapshot dos metadados, status e data de inclusão; modelos não dependem de DTO; testes de JSON | — |
| 03 | Persistência local | `LocalStorage` (SharedPreferences), `LibraryRepository`, preferências; incluir, atualizar, remover e recuperar; unicidade | Preferências e biblioteca persistem entre execuções; dados acessíveis offline | — |
| 04 | Google Books API | Cliente Dio, `BooksApiService`, `GoogleBooksVolumeDto` → `Book`, `BooksRepository`; busca por título/autor e detalhes; tratamento de erros HTTP, respostas vazias e campos ausentes | Busca retorna livros; metadados convertidos; campos ausentes e erros de conexão tratados | — |
| 05 | Onboarding | Tela conforme design; nome e um ou mais gêneros; validação; persistência; fluxo inicial | Primeiro acesso abre o onboarding; execuções seguintes abrem a Home | — |
| 06 | Biblioteca | My Library com livros locais; filtros All / Want to Read / Reading / Completed; alterar status; remover; abrir detalhes; estado vazio | Filtros e status funcionam e persistem; remoção reflete na hora; funciona offline | — |
| 07 | Explore e detalhes | Busca em grid com estados de loading, erro, vazio e sem resultados; detalhes com capa, título, autores, descrição, editora, data e páginas; incluir/remover; status do livro salvo | Busca via Google Books; resultados abrem detalhes; metadados ausentes tratados | — |
| 08 | Home | Saudação com o nome; recomendações pelos gêneros escolhidos; estados de loading, erro e vazio | Recomendações consideram os gêneros e abrem detalhes; **sem recomendação por IA** | — |
| 09 | Integração e acabamento | Revisar navegação, integração Stores/Repositories/Services, offline, SafeArea, responsividade, comparação com o Stitch | Tudo integrado, segue o design system, sem erros críticos | — |
| 10 | Testes e validação | Testes de modelos, repositórios, persistência, biblioteca, busca e onboarding; testes manuais | Format, analyze e test executados; fluxos validados em emulador | — |

Ordem: 01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10. Componentes visuais podem ser adiantados quando não criarem dependência artificial.

## 4. Regras de trabalho
- Nunca entregar tudo de uma vez: cada etapa vira tarefas menores, concluídas e validadas antes de avançar.
- Sem requisição HTTP nem persistência dentro de widgets.
- DTO externo nunca vaza para modelo interno.
- Ao fim de cada etapa: revisar arquivos, rodar `dart format .`, `flutter analyze` e `flutter test`, e registrar o que ficou pronto e o que ficou pendente. Validação só conta se os comandos foram executados.

## 5. Definition of Done do MVP
- [ ] Onboarding cadastra nome e gêneros.
- [ ] Preferências persistidas localmente.
- [ ] Home com saudação e recomendações por gênero.
- [ ] Explore pesquisa por título ou autor.
- [ ] Detalhes mostram os metadados disponíveis.
- [ ] Adicionar e remover livros da biblioteca.
- [ ] Biblioteca filtra por status de leitura.
- [ ] Atualizar o status dos livros.
- [ ] Biblioteca funciona offline.
- [ ] Navegação entre Home, Explore e Library.
- [ ] Estados de loading, erro e vazio.
- [ ] Interface segue o Nocturne Editorial.
- [ ] `flutter analyze` e `flutter test` executados.
- [ ] Fluxos principais testados manualmente.
