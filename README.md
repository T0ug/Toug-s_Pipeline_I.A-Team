# Toug's Pipeline I.A - Team

Pipeline Codex-native para desenvolvimento assistido por IA.

O objetivo nao e criar mais um conjunto de prompts. O objetivo e dar ao Codex um modo de trabalho previsivel, rastreavel e verificavel em projetos reais.

## Instalacao Rapida

No root de qualquer projeto:

```powershell
npm install -D toug-i.a-pipeline-team
```

Esse comando instala automaticamente:

```txt
AGENTS.md
.agents/
.github/
```

Depois abra o projeto no Codex e pergunte:

```txt
qual o estado atual da pipeline?
```

Para conferir pelo terminal:

```powershell
npx toug-pipeline doctor
```

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
|   |   |-- team-planning/
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
docs/project/team_plan.md
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

### `team-planning`

Prepara o mapa de trabalho para equipe.

Uso esperado:

```txt
temos 3 pessoas trabalhando com Codex, organize as tasks
```

O Codex deve atualizar:

```txt
docs/project/team_plan.md
```

E considerar:

- owner da task;
- branch sugerida;
- dependencias;
- tarefas paralelizaveis;
- uma task por PR.

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
onboard
scan
plan-team
claim
start
before-work
after-work
review
complete
validate
```

Exemplos:

```powershell
./.agents/scripts/pipeline.ps1 onboard -Root .
./.agents/scripts/pipeline.ps1 plan-team -Root . -Members "Ana,Bruno,Camila"
./.agents/scripts/pipeline.ps1 claim -Root . -Task TASK-001 -Owner "Ana"
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

1. varrer o repositorio inteiro antes de criar tasks;
2. encontrar docs mesmo em subpastas ou fora do padrao;
3. inspecionar README, configs, manifests, testes, codigo, migrations, CI e deploy;
4. gerar `docs/project/onboarding_research.md` e `docs/project/code_map.md`;
5. criar ou atualizar `docs/project/` com fatos descobertos;
6. criar tasks apenas para trabalho ativo, lacunas reais ou pedido explicito do usuario;
7. rodar `validate_project.ps1`;
8. recomendar a proxima acao segura.

Comando usado pelo Codex quando pratico:

```powershell
./.agents/scripts/pipeline.ps1 onboard -Root .
```

Regra importante: projeto existente nao deve ser tratado como projeto novo so porque nao tem docs canonicos.

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

No root do projeto alvo, rode:

```powershell
npm install -D toug-i.a-pipeline-team
```

Pronto. Durante o `npm install`, o pacote copia automaticamente para o projeto:

```txt
AGENTS.md
.agents/
.github/
```

Depois abra o projeto no Codex e pergunte:

```txt
qual o estado atual da pipeline?
```

Para verificar pelo terminal:

```powershell
npx toug-pipeline doctor
```

### Projeto Novo

Se o projeto ainda nao tem docs da pipeline, rode tambem:

```powershell
npx toug-pipeline init --with-docs
npx toug-pipeline doctor
```

Isso cria:

```txt
docs/project/
docs/tasks/
docs/releases/
docs/archive/
```

### Projeto Existente

Para projeto que ja tem codigo, docs fora do padrao, ou historico em andamento, instale apenas a superficie da pipeline:

```powershell
npm install -D toug-i.a-pipeline-team
```

Depois, no Codex, peca:

```txt
faca o onboarding deste projeto existente para a pipeline
```

O Codex deve usar `onboard-existing-project`, varrer o repositorio inteiro, encontrar docs fora do padrao e so depois preencher `docs/project/`.

### Atualizar Pipeline

Para atualizar uma instalacao ja existente:

```powershell
npx toug-pipeline upgrade
```

O `upgrade` cria backup local de `AGENTS.md`, `.agents/` e `.github/` antes de sobrescrever.

Se a instalacao ficou parcial, rode:

```powershell
npx toug-pipeline init
npx toug-pipeline doctor
```

O `init` preserva arquivos existentes e preenche arquivos faltantes dentro de `.agents/` e `.github/`.

Em projetos com acentos no caminho, como `Menu de Automacoes`, use a versao `0.3.2` ou superior. Ela corrige casos em que o npm/Node recebe o caminho em formato mojibake e tenta criar arquivos em uma pasta paralela com caracteres quebrados.

### Evitar Instalacao Automatica

Se voce quiser instalar a dependencia sem copiar a pipeline automaticamente:

```powershell
$env:TOUG_PIPELINE_SKIP_AUTO_INSTALL = "1"
npm install -D toug-i.a-pipeline-team
```

### Desenvolvimento local deste pacote

No repositorio da pipeline:

```powershell
npm link
```

No projeto alvo:

```powershell
npx toug-pipeline init --with-docs
npx toug-pipeline doctor
```

### Sem instalacao global

No projeto alvo, chamando o CLI pelo caminho local do repositorio da pipeline:

```powershell
node "C:\path\to\Toug-s_Pipeline_I.A - Team\cli\index.js" init --with-docs
node "C:\path\to\Toug-s_Pipeline_I.A - Team\cli\index.js" doctor
```

Depois da instalacao, dentro do Codex, o usuario nao precisa decorar comandos. Basta abrir o projeto e pedir:

```txt
qual o estado atual da pipeline?
```

Para verificacao manual:

```powershell
./.agents/scripts/validate_pipeline.ps1 -Root .
./.agents/scripts/init_project.ps1 -Root .
./.agents/scripts/status_pipeline.ps1 -Root .
```

## Colaboracao Em Equipe

Para equipes usando Codex em paralelo:

- manter `docs/project/team_plan.md` atualizado;
- fazer claim de task antes de implementar;
- uma task por branch;
- uma task por PR;
- evitar duas pessoas trabalhando na mesma task ao mesmo tempo;
- tratar `docs/project/` como memoria compartilhada protegida;
- registrar execucao em `handoff.md`;
- registrar validacao em `review.md`.

Comandos usados pelo Codex quando pratico:

```powershell
./.agents/scripts/pipeline.ps1 plan-team -Root . -Members "Ana,Bruno,Camila"
./.agents/scripts/pipeline.ps1 claim -Root . -Task TASK-001 -Owner "Ana"
```

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

O CLI em `cli/` existe apenas como instalador e verificador da pipeline em projetos reais.

Ele nao substitui o Codex, nao executa o trabalho da pipeline e nao cria uma camada paralela de workflow. A superficie operacional continua sendo:

```txt
AGENTS.md
.agents/skills/
.agents/scripts/
docs/project/
docs/tasks/
```

Comandos:

```powershell
npm install -D toug-i.a-pipeline-team
npx toug-pipeline init
npx toug-pipeline init --with-docs
npx toug-pipeline doctor
npx toug-pipeline upgrade
```

Significado:

- `npm install -D toug-i.a-pipeline-team`: instala o pacote e copia automaticamente `AGENTS.md`, `.agents/` e `.github/` para o projeto atual;
- `npx toug-pipeline init`: copia `AGENTS.md`, `.agents/` e `.github/` para o projeto atual;
- `npx toug-pipeline init --with-docs`: tambem inicializa `docs/project`, `docs/tasks`, `docs/releases` e `docs/archive`;
- `npx toug-pipeline doctor`: verifica se a instalacao esta no modelo Codex-native atual e alerta se `docs/project` ainda nao foi inicializado;
- `npx toug-pipeline upgrade`: cria backup local dos arquivos atuais da pipeline e depois atualiza `AGENTS.md`, `.agents/` e `.github/`.

Para impedir a instalacao automatica durante `npm install`, use:

```powershell
$env:TOUG_PIPELINE_SKIP_AUTO_INSTALL = "1"
npm install -D toug-i.a-pipeline-team
```

O `doctor` valida que existem os arquivos atuais e que nao existem estruturas legadas:

```txt
.agents/agents/
.agents/workflows/
.agents/rules/
.agents/core/
.agents/registry/
```

A referencia principal desta versao e este README junto com `.agents/references/codex_installation_model.md`.

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
