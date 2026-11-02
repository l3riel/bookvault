# PRD — BookVault

> **Dono:** Gabriel Arthur (arquiteto) · **Status:** rascunho (preenchido pela IA a partir do [Plano de Execução](PLANO.md) e do [design](design/); aguarda revisão)
> Este documento é a fonte da verdade do *o quê* e do *porquê*. A IA implementa a partir daqui e das specs em `docs/specs/`; ela não inventa requisito.

## 1. Problema
Quem lê muito perde o controle do que quer ler, do que está lendo e do que já terminou, e descobre livros novos de forma solta. O BookVault reúne descoberta e organização num acervo pessoal no celular.

## 2. Público
Leitores que querem descobrir livros pelos gêneros de que gostam e manter uma estante pessoal com status de leitura, mesmo sem internet.

## 3. Objetivos da Semana da Computação
- [ ] App mobile funcional demonstrando o fluxo onboarding → Home → Explore → detalhes → biblioteca.
- [ ] Interface fiel ao design system Nocturne Editorial.
- [ ] Desenvolvimento IA-driven documentado (PRD, ADRs, specs, commits atômicos).

## 4. Escopo do MVP
| # | Funcionalidade | Prioridade | Spec |
|---|---|---|---|
| F0 | Preparação: tema, rotas, estrutura e injeção de dependências | Must | [S01](specs/S01-preparacao.md) |
| F1 | Onboarding: nome e um ou mais gêneros, salvos no aparelho; só aparece no primeiro acesso | Must | — |
| F2 | Biblioteca pessoal: listar, filtrar por status (Quero ler, Lendo, Concluído), mudar status, remover | Must | — |
| F3 | Explore: busca por título ou autor na Google Books API, resultados em grid | Must | — |
| F4 | Detalhes do livro: capa, título, autores, descrição, editora, data, páginas; adicionar/remover da biblioteca | Must | — |
| F5 | Home: saudação com o nome e recomendações pelos gêneros escolhidos | Must | — |

## 5. Fora de escopo
- Recomendação por IA.
- Conta de usuário, login e sincronização em nuvem.
- Leitor de e-book, progresso por página, metas e estatísticas de leitura.
- Cadastro manual de livros (a fonte é a Google Books API).

## 6. Requisitos não funcionais
- Plataformas: Android (alvo principal) e Web (demonstração).
- Offline: biblioteca e preferências funcionam sem internet; busca e recomendações exigem conexão e tratam a falta dela.
- Estados de loading, erro e vazio em todas as telas com dados.
- Respeitar SafeArea e alvos de toque de 48px.
- Idioma da interface: **a definir** (o design está em inglês; o CLAUDE.md pede pt-BR).

## 7. Critérios de sucesso
- Todos os itens da Definition of Done do [plano](PLANO.md#5-definition-of-done-do-mvp) marcados.
- `dart format`, `flutter analyze` e `flutter test` passando no CI.
