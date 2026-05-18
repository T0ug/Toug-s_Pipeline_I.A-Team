# Toug's Pipeline I.A

Um sistema de desenvolvimento com IA baseado em agentes, workflows, templates e regras operacionais.

Mais do que um conjunto de prompts, esta pipeline define **como a IA deve trabalhar** dentro de um projeto.

---

## 🎯 Objetivo

Transformar o uso de IA em um processo:

- estruturado
- rastreável
- consistente entre sessões
- seguro contra sobrescrita e perda de contexto

---

## 🧠 Conceito central

A pipeline se baseia em três pilares:

### 1. Estrutura (`.agents/`)
Define como a IA funciona.

### 2. Estado do projeto (`docs/`)
Define o que o projeto é.

### 3. Regras (`AGENTS.md` + `rules/`)
Define como a IA deve se comportar.

---

## 🧱 Estrutura do sistema

```txt
.agents/
  core/
  agents/
  skills/
  workflows/
  templates/
  registry/
  rules/

docs/
AGENTS.md
```

---

## ⚠️ Uso obrigatório (IMPORTANTE)

Para que a pipeline funcione corretamente, é obrigatório:

### 1. Adicionar o AGENTS.md no root do projeto

Este arquivo contém as regras globais do sistema.

Sem ele:
- a pipeline vira apenas sugestão
- o comportamento da IA se torna inconsistente

---

### 2. Utilizar as Rules da pipeline

A pasta:

```txt
.agents/rules/
```

já contém regras que:

- forçam o uso da pipeline
- garantem leitura de `docs/`
- impedem troca de agentes indevida
- evitam execução sem contexto

Essas rules são automaticamente integradas ao projeto.

---

### 3. Usar `docs/` como fonte de verdade

Todos os artefatos do projeto devem viver em:

```txt
docs/
```

Incluindo:

- idea.md
- scope.md
- tasks.md
- project_status.md
- decision_log.md
- handoff.md

A IA deve sempre ler esses arquivos antes de agir.

---

## 🚀 Instalação

Clone o repositório:

```bash
git clone https://github.com/T0ug/Toug-s_Pipeline_I.A.git
cd Toug-s_Pipeline_I.A
npm install
npm link
```

---

## 📦 Instalação no projeto

No projeto onde deseja usar a pipeline:

```bash
toug-pipeline init
toug-pipeline doctor
```

---

## ⚠️ Importante

O comando `init` deve ser executado no projeto alvo, não dentro da pipeline.

---

## ▶️ Como iniciar um projeto

Você deve iniciar sempre com um workflow.

### Novo projeto:

```txt
Use o workflow start_project
```

### Projeto já existente:

```txt
Use o workflow onboard_existing_project
```

### Nova sessão:

```txt
Use o workflow resume_session
```

---

## 🔁 Fluxo da pipeline

A execução segue sempre este ciclo:

```txt
Discovery → Architect → Executor → Reviewer → Orchestrator
```

---

## 🧠 Agentes

| Agente | Função |
|------|-------|
| Discovery | define escopo |
| Architect | define estrutura |
| Executor | implementa |
| Reviewer | valida |
| Orchestrator | coordena |
| Project Research | reconstrói contexto de projeto existente |

---

## ⚙️ Workflows principais

- `start_project` → inicia projeto
- `structure_project` → define arquitetura
- `execute_task` → executa tasks
- `resume_session` → retoma contexto
- `onboard_existing_project` → integra projeto existente

---

## 📋 Tasks

O planejamento vive em:

```txt
docs/tasks.md
```

Regras:

- é a única fonte de verdade do planejamento
- não criar listas paralelas
- não executar fora de ordem
- qualquer mudança relevante deve ser registrada em `docs/decision_log.md`

---

## 🔄 Handoff

Toda task deve gerar:

```txt
docs/handoff.md
```

Sem handoff:
→ a task não está concluída

O handoff deve conter informação suficiente para:

- outro agente continuar sem depender do chat
- o Reviewer validar a entrega com evidência

---

## 🔍 Validação

Nenhuma task avança sem:

- evidência
- validação
- review

A revisão deve gerar:

```txt
docs/review_report.md
```

---

## 🧠 Regras do sistema

### AGENTS.md

Define as regras globais do sistema:

- `docs/` como fonte de verdade
- ativação correta de agentes
- disciplina da pipeline
- bloqueio em caso de contexto inconsistente

### Rules (`.agents/rules/`)

Funcionam como enforcement ativo da pipeline.

Rules recomendadas:

- `pipeline_enforcement.md`
- `context_enforcement.md`
- `task_discipline.md`
- `agent_control.md`
- `execution_safety.md`

Essas rules reforçam comportamento e devem operar preferencialmente em modo **Always On**.

---

## 🧠 Continuidade entre sessões

Esta pipeline foi desenhada para funcionar mesmo quando o chat perde contexto.

Para retomar com segurança:

1. use `resume_session`
2. mantenha `docs/` atualizado
3. nunca confie apenas na memória da conversa

Arquivos mínimos de retomada:

- `docs/project_status.md`
- `docs/handoff.md`
- `docs/tasks.md`
- `docs/decision_log.md`

---

## 🧩 Projeto já em andamento

Se o projeto não nasceu dentro da pipeline, não use `start_project` direto.

Use:

```txt
Use o workflow onboard_existing_project
```

Esse workflow serve para:

- analisar código e docs existentes
- reconstruir intenção e estado atual
- gerar artefatos compatíveis com a pipeline principal

---

## ⚠️ Sem essas regras

A pipeline:

- perde consistência
- perde controle
- vira sugestão

---

## 🧠 Observações importantes

- Não confiar na memória do chat
- Sempre usar `docs/`
- Nunca pular workflows
- Nunca misturar papéis de agentes
- Nunca tratar projeto existente como se fosse projeto novo
- Nunca aprovar task sem evidência suficiente

---

## 🎯 Conclusão

Essa pipeline não é apenas um conjunto de prompts.

Ela é um sistema para transformar IA em uma ferramenta de desenvolvimento previsível, controlada e reutilizável entre sessões.

---

## 📌 Status

Versão atual: v1

Base pronta para uso, personalização e evolução contínua.
