# Toug's Pipeline I.A - Team

Pipeline Codex-native para desenvolvimento assistido por IA.

O objetivo nao e criar mais um conjunto de prompts. O objetivo e dar ao Codex um modo de trabalho previsivel, rastreavel e verificavel em projetos reais.

## Filosofia

A pipeline organiza o trabalho em tres camadas:

```txt
AGENTS.md       instrucoes sempre ativas para o Codex
.agents/        skills, scripts, templates e referencias
docs/           memoria persistente do projeto
```

O chat nao e fonte de verdade. O estado do projeto deve ser reconstruido a partir de arquivos versionados.

## Modelo Codex-Native

Esta pipeline foi desenhada exclusivamente para Codex.

Superficie ativa:

```txt
AGENTS.md
.agents/skills/*/SKILL.md
.agents/scripts/*.ps1
docs/project/
docs/tasks/
```

Superficie auxiliar:

```txt
.agents/templates/
.agents/references/
```

Nao fazem parte do modelo atual:

```txt
.agents/agents/
.agents/workflows/
.agents/rules/
.agents/core/
.agents/registry/
```

Papeis como Executor, Reviewer e Orchestrator continuam existindo como fases do processo, mas nao como arquivos ou agentes paralelos. No Codex, o fluxo deve ser expresso por `AGENTS.md`, skills e scripts.

## Estrutura

```txt
.
|-- AGENTS.md
|-- .agents/
|   |-- skills/
|   |   |-- pipeline-router/
|   |   |-- execute-task/
|   |   |-- review-delivery/
|   |   |-- resume-session/
|   |   |-- onboard-existing-project/
|   |   `-- structure-project/
|   |-- scripts/
|   |-- templates/
|   `-- references/
`-- docs/
    |-- project/
    |-- tasks/
    |-- releases/
    `-- archive/
```

## Memoria Do Projeto

Arquivos globais principais:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
```

Cada task tem sua propria pasta:

```txt
docs/tasks/TASK-XXX-name/
  scope.md
  implementation_plan.md
  decisions.md
  handoff.md
  review.md
```

Modelo mental:

```txt
Branch = veiculo temporario de implementacao
Task = unidade historica de trabalho
docs/project/ = memoria permanente
docs/tasks/ = memoria de execucao
docs/releases/ = snapshots de entrega
```

Nunca organize documentacao por branch.

## Skills

### `pipeline-router`

Entrada padrao da pipeline.

Use para pedidos naturais de estado, planejamento, criacao de task, implementacao, review, validacao ou onboarding. O objetivo e que o usuario nao precise lembrar nomes de skills nem scripts.

Exemplos:

```txt
qual o estado atual da pipeline?
corrija o bug do webhook duplicado
revisa a entrega atual
comece uma task para login com Google
```

O Codex deve rotear automaticamente para a skill correta e usar scripts quando pratico.

### `structure-project`

Inicializa a estrutura `docs/` em um projeto novo.

Uso esperado:

```txt
Use structure-project para preparar este repositorio para a pipeline.
```

### `onboard-existing-project`

Analisa um projeto existente e cria a memoria minima em `docs/project/` e `docs/tasks/`.

Uso esperado:

```txt
Use onboard-existing-project para alinhar este projeto com a pipeline.
```

### `resume-session`

Reconstrui o estado atual do projeto antes de continuar.

Tambem deve responder perguntas como:

```txt
qual o estado atual da pipeline?
onde paramos?
qual task esta ativa?
qual o proximo passo seguro?
```

### `execute-task`

Executa uma task definida, mantendo escopo, arquitetura e handoff.

Uso esperado:

```txt
Use execute-task para TASK-014-google-login.
```

### `review-delivery`

Valida uma entrega com base em escopo, handoff, evidencias e arquitetura.

Uso esperado:

```txt
Use review-delivery para TASK-014-google-login.
```

## Scripts

Os scripts tornam a pipeline verificavel. O Codex deve preferir scripts a boilerplate manual quando possivel.

### Piloto automatico

```powershell
./.agents/scripts/pipeline.ps1 status -Root .
```

Acoes disponiveis:

```txt
status
init-project
start
before-work
after-work
review
complete
validate
```

Exemplos:

```powershell
./.agents/scripts/pipeline.ps1 start -Root . -Name "login com Google"
./.agents/scripts/pipeline.ps1 before-work -Root . -Task TASK-001
./.agents/scripts/pipeline.ps1 after-work -Root . -Task TASK-001
./.agents/scripts/pipeline.ps1 review -Root . -Task TASK-001
```

O usuario normalmente nao precisa chamar isso manualmente. O Codex deve usar este script por tras da conversa.

### Validar a propria pipeline

```powershell
./.agents/scripts/validate_pipeline.ps1 -Root .
```

### Inicializar docs de projeto

```powershell
./.agents/scripts/init_project.ps1 -Root .
```

Cria:

```txt
docs/project/
docs/tasks/
docs/releases/
docs/archive/
```

### Criar uma task

```powershell
./.agents/scripts/init_task.ps1 -Root . -Id TASK-001 -Name "first task"
```

Cria:

```txt
docs/tasks/TASK-001-first-task/
  scope.md
  implementation_plan.md
  decisions.md
  handoff.md
  review.md
```

Tambem registra a task em:

```txt
docs/project/backlog.md
```

### Validar projeto

```powershell
./.agents/scripts/validate_project.ps1 -Root .
```

Verifica se o projeto esta no modelo Codex-native da pipeline.

### Validar task

```powershell
./.agents/scripts/validate_task.ps1 -Root . -Task TASK-001 -Stage ready
```

Estagios:

```txt
ready
implemented
reviewed
complete
```

### Ver estado atual

```powershell
./.agents/scripts/status_pipeline.ps1 -Root .
```

Esse script informa:

- validacao do projeto;
- task ativa;
- pasta da task;
- estado dos arquivos da task;
- se handoff/review estao completos;
- proxima acao segura.

## Fluxo Recomendado

### Projeto novo

```txt
Use structure-project.
```

Depois:

```powershell
./.agents/scripts/init_project.ps1 -Root .
./.agents/scripts/init_task.ps1 -Root . -Id TASK-001 -Name "primeira task"
```

### Projeto existente

```txt
Use onboard-existing-project.
```

O Codex deve:

1. inspecionar estrutura, README, configs, testes e codigo principal;
2. criar ou atualizar `docs/project/`;
3. criar tasks iniciais apenas quando houver trabalho ativo claro;
4. rodar `validate_project.ps1`;
5. recomendar a proxima acao segura.

### Nova sessao

```txt
qual o estado atual da pipeline?
```

O Codex deve usar `pipeline-router`, rodar ou seguir `pipeline.ps1 status`, ler `docs/project/` e `docs/tasks/`, e responder com o estado atual.

### Implementacao

```txt
Use execute-task para TASK-XXX-name.
```

Ao concluir, a task deve ter handoff atualizado:

```txt
docs/tasks/TASK-XXX-name/handoff.md
```

### Review

```txt
Use review-delivery para TASK-XXX-name.
```

O resultado deve ser registrado em:

```txt
docs/tasks/TASK-XXX-name/review.md
```

## Criterios De Conclusao

Uma task de implementacao so esta concluida quando:

- o escopo foi cumprido;
- a validacao relevante foi executada ou justificada;
- `handoff.md` foi atualizado;
- decisoes locais foram registradas em `decisions.md`;
- riscos e pendencias ficaram explicitos.

Uma task so esta validada quando:

- `review.md` foi preenchido;
- o resultado e `approved`, `approved_with_notes` ou `rejected`;
- evidencias foram verificadas.

## Instalacao Em Projetos Reais

Instale no root do projeto alvo:

```txt
AGENTS.md
.agents/
.github/
```

Depois rode:

```powershell
./.agents/scripts/validate_pipeline.ps1 -Root .
./.agents/scripts/init_project.ps1 -Root .
./.agents/scripts/status_pipeline.ps1 -Root .
```

## Colaboracao Em Equipe

Para equipes usando Codex em paralelo:

- uma task por branch;
- uma task por PR;
- evitar duas pessoas trabalhando na mesma task ao mesmo tempo;
- tratar `docs/project/` como memoria compartilhada protegida;
- registrar execucao em `handoff.md`;
- registrar validacao em `review.md`.

O template de PR fica em:

```txt
.github/pull_request_template.md
```

O workflow de CI fica em:

```txt
.github/workflows/pipeline.yml
```

Ele valida automaticamente a pipeline, valida `docs/project/` quando inicializado e tenta validar a task inferida do nome da branch ou titulo do PR quando houver `TASK-XXX`.

## CLI

O pacote possui um CLI em `cli/`, mas a superficie atual da pipeline e Codex-native e baseada em `AGENTS.md`, `.agents/skills` e `.agents/scripts`.

Antes de depender do CLI para instalacao ou doctor, confira se ele esta alinhado com a estrutura atual. A referencia principal desta versao e este README junto com:

```txt
.agents/references/codex_installation_model.md
```

## Principios

- Codex deve ler arquivos, nao depender do chat.
- Tasks devem ser historicas e isoladas.
- Mudancas devem ser pequenas, rastreaveis e revisaveis.
- Decisoes locais ficam na task.
- Decisoes globais ficam em `docs/project/decision_log.md`.
- Scripts devem transformar disciplina em contrato verificavel.

## Status

Versao atual: v3 Codex-native.

Foco atual: uso com Codex, roteamento automatico por `pipeline-router`, scripts deterministico e colaboracao via PR/CI.
