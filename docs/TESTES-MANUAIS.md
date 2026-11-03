# Roteiro de testes manuais

Roteiro para conferir o BookVault no aparelho antes de uma entrega. Cada passo diz o que fazer e o que tem que aparecer. Se algo diferente aparecer, anote o número do passo.

## Preparação
1. Crie `config/api_keys.json` a partir de `config/api_keys.example.json` com a chave da Google Books.
2. Abra o emulador: `flutter emulators --launch Pixel_8_API_36`.
3. Desinstale versões antigas para começar do zero: `adb uninstall br.com.l3riel.bookvault`.
4. Rode: `flutter run --dart-define-from-file=config/api_keys.json`.
5. Deixe o log aberto. Nenhum passo pode gerar exceção (`EXCEPTION CAUGHT`) no log.

## A. Abertura e onboarding
| # | Faça | Deve aparecer |
|---|---|---|
| A1 | Abra o app pela primeira vez | Abertura escura (sem flash branco), depois a tela de boas-vindas |
| A2 | Sem nome ou sem gênero | O botão "Começar" fica desabilitado |
| A3 | Digite um nome e escolha 2 ou 3 gêneros | Os gêneros escolhidos ficam marcados em dourado |
| A4 | Toque em "Começar" | Vai para o Início com "Bom dia/Boa tarde/Boa noite, <nome>" |
| A5 | Feche o app e abra de novo | Abre direto no Início, sem repetir o onboarding |

## B. Início (Home)
| # | Faça | Deve aparecer |
|---|---|---|
| B1 | Espere carregar | "Destaque para você" com um livro e uma fileira por gênero escolhido |
| B2 | Toque em "Ver livro" no destaque | Detalhes do livro, sem carregamento extra |
| B3 | Volte e toque no 🔖 do destaque | O ícone muda para "já está na biblioteca" |
| B4 | Toque em "Ver todos" de uma fileira | Explorar já buscando aquele gênero |
| B5 | Volte ao Início e puxe a tela para baixo | Recarrega as recomendações |
| B6 | Toque na lupa da barra superior | Abre o Explorar |

## C. Explorar e Detalhes
| # | Faça | Deve aparecer |
|---|---|---|
| C1 | Abra Explorar | Campo de busca e sugestões dos seus gêneros |
| C2 | Busque "tolkien" | Carregando, depois a lista com a contagem ("N resultados") |
| C3 | Busque "xqzwkjhv" | "Nenhum livro corresponde a ..." |
| C4 | Toque num resultado | Detalhes com capa, título, autores, ano, editora, páginas e sinopse (o que houver) |
| C5 | Toque em "Adicionar à biblioteca" | Aparece o seletor de status, marcado em "Quero ler" |
| C6 | Mude para "Lendo" | O status muda na hora |

## D. Biblioteca
| # | Faça | Deve aparecer |
|---|---|---|
| D1 | Abra a aba Biblioteca | Os livros salvos, com capa, autor e selo de status |
| D2 | Toque nos filtros "Quero ler", "Lendo", "Concluídos" | Contagens certas; livros de outros status ficam apagados |
| D3 | Escolha um filtro sem livros | "Nenhum livro em <status>." |
| D4 | Nas opções de um livro, mude o status | Selo e contagens se atualizam |
| D5 | Nas opções, remova e cancele | O livro continua |
| D6 | Remova e confirme | O livro sai da lista |
| D7 | Remova todos | "Sua biblioteca está vazia" com botão para o Explorar |
| D8 | Adicione um livro, feche e reabra o app | O livro continua lá com o mesmo status |

## E. Navegação
| # | Faça | Deve aparecer |
|---|---|---|
| E1 | Troque entre Início, Explorar e Biblioteca | Cada aba mantém o seu estado (a busca do Explorar não some) |
| E2 | Nos Detalhes, use o voltar do sistema | Volta para a tela anterior |
| E3 | Role os Detalhes até o fim | O texto não fica sob a barra de gestos |

## F. Offline (modo avião)
`adb shell cmd connectivity airplane-mode enable` (desligar: `disable`).

| # | Faça | Deve aparecer |
|---|---|---|
| F1 | Abra a Biblioteca | Os livros salvos aparecem; capas viram o marcador |
| F2 | Abra os Detalhes de um livro salvo | Abre com os dados salvos; dá para mudar o status |
| F3 | Puxe o Início para recarregar | Erro em pt-BR com "Tentar de novo" |
| F4 | Busque no Explorar | Erro em pt-BR com "Tentar de novo" |
| F5 | Desligue o modo avião e toque em "Tentar de novo" | Os dados carregam |

## G. Web (Chrome)
`flutter run -d chrome --dart-define-from-file=config/api_keys.json`

| # | Faça | Deve aparecer |
|---|---|---|
| G1 | Abra numa janela larga | Coluna central de no máximo 600 px; aba com título "BookVault" |
| G2 | Faça o onboarding e espere o Início | Recomendações com capas reais |
| G3 | Adicione um livro e recarregue a página | O livro continua na Biblioteca |

## Registro de execuções
| Data | Alvo | Resultado |
|---|---|---|
| 02/11/2026 | Emulador Pixel 8, API 36, instalação limpa | A–F passaram, sem exceções no log. G validado no Chrome na S09, no mesmo dia, sem mudança de código web depois |
