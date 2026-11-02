# Design — Nocturne Editorial

Referências visuais do BookVault, exportadas do Google Stitch.

- [`DESIGN.md`](DESIGN.md): design system (tokens de cor, tipografia, espaçamento, raios e componentes).
- [`screens/`](screens/): uma pasta por tela, com `screen.png` (imagem de referência) e `code.html` (protótipo HTML/Tailwind do Stitch).

| Tela | Pasta | Feature |
|---|---|---|
| Onboarding | [`screens/onboarding/`](screens/onboarding/) | `lib/features/onboarding/` |
| Home | [`screens/home/`](screens/home/) | `lib/features/home/` |
| Explore | [`screens/explore/`](screens/explore/) | `lib/features/explore/` |
| Book Details | [`screens/book_details/`](screens/book_details/) | `lib/features/book_details/` |
| My Library | [`screens/my_library/`](screens/my_library/) | `lib/features/library/` |

Os protótipos HTML são só referência visual: os tokens valem pelo `DESIGN.md` e o código Flutter não deve copiar a estrutura do HTML.
