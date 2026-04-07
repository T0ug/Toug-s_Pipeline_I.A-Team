# Method

## Objetivo

Definir como o sistema de desenvolvimento com IA opera, garantindo:

- consistência
- controle
- previsibilidade
- rastreabilidade

Este método define:

- fluxo de execução
- responsabilidades dos agentes
- uso de skills e workflows
- regras de progressão
- regras de bloqueio
- fonte de verdade do projeto

---

## Princípios fundamentais

### 1. Intenção antes de implementação
Nenhum código é produzido sem definição validada.

### 2. Clareza antes de velocidade
Ambiguidade nunca é aceitável.

### 3. Nada importante implícito
Toda decisão relevante deve ser registrada.

### 4. Execução controlada
Nenhuma execução ocorre sem contexto suficiente.

### 5. Validação obrigatória
Nenhuma entrega avança sem revisão.

### 6. Progressão disciplinada
O projeto evolui por etapas definidas.

---

## Fonte de verdade do sistema

A única fonte confiável de estado do projeto é:

docs/

Chat NÃO é fonte de verdade.

---

## Local dos artefatos

Todos os artefatos devem existir em docs/:

- idea.md
- scope.md
- non_goals.md
- decision_log.md
- implementation_plan.md
- tasks.md
- architecture.md
- project_status.md
- handoff.md
- review_report.md

---

## Estrutura do sistema

.agents/
docs/
GEMINI.md

---

## Regras do sistema

### GEMINI.md
Define regras globais.

### Rules (.agents/rules/)
Aplicam enforcement ativo:

- pipeline_enforcement
- context_enforcement
- task_discipline
- agent_control
- execution_safety

Se houver conflito:
→ regras prevalecem

---

## Protocolo de ativação

Agentes só podem ser ativados via:

- workflow explícito
- instrução direta do usuário

Proibido:

- troca automática de agente
- mudança implícita de papel

---

## Continuidade entre sessões

Usar workflow:

resume_session

Leitura obrigatória:

- docs/project_status.md
- docs/handoff.md
- docs/tasks.md
- docs/decision_log.md

---

## Onboarding de projeto existente

Usar:

onboard_existing_project

---

## Ciclo de vida do projeto

1. Discovery → clarify_intent
2. Architecture → design_architecture
3. Execution → implement_task
4. Review → validate_delivery

---

## Fluxo

Discovery → Architect → Executor → Reviewer → Orchestrator

---

## Orchestrator

Responsável por:

- determinar estado
- detectar inconsistências
- decidir próxima ação

---

## Controle de tasks

docs/tasks.md é a única fonte de verdade.

---

## Controle de execução

Fluxo obrigatório:

Executor → Handoff → Reviewer → Orchestrator

Sem qualquer etapa:
→ BLOQUEAR

---

## Regra final

Se houver dúvida:
→ garantir consistência

---

## Versão

v2
