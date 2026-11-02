# ADR 0001 — Flutter com arquitetura feature-first

- **Data:** 2026-11-02
- **Status:** aceita

## Contexto
Projeto da Semana da Computação, desenvolvido de forma *IA-driven*: o arquiteto define requisitos e decisões, a IA implementa. Precisa rodar no celular (Android) e ser fácil de demonstrar (web).

## Decisão
Usar Flutter/Dart com organização feature-first e camadas `domain`/`data`/`presentation` por feature.

## Alternativas consideradas
- Organização por camada global (`lib/models`, `lib/screens`…): mistura features e fica difícil delimitar o que a IA pode mexer em cada tarefa.

## Consequências
- Cada spec mapeia para uma pasta em `lib/features/`, o que deixa o escopo de cada tarefa da IA claro e revisável.
- Um pouco mais de pastas no início.
