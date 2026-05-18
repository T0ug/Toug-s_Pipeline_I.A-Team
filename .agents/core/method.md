# Method

## Objetivo

Definir como o sistema de desenvolvimento com IA opera, garantindo:
<<<<<<< HEAD
=======

- consistência
- controle
- previsibilidade
- rastreabilidade
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

- consistência
- controle
- previsibilidade
- rastreabilidade

<<<<<<< HEAD
Este método define:

- fluxo de execução
- responsabilidades dos agentes
- uso de skills e workflows
- regras de progressão
- regras de bloqueio
=======
- ordem de execução
- responsabilidades dos agentes
- uso das skills
- critérios de progressão e bloqueio
- regras de ativação
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5
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

<<<<<<< HEAD
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
=======
## Local padrão dos artefatos

Todos os artefatos devem ser criados em:

docs/
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

---

## Estrutura do sistema

<<<<<<< HEAD
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
=======
.agents/  
docs/  
GEMINI.md  

---

## Regras do sistema (ENFORCEMENT)

### GEMINI.md
Define regras globais obrigatórias.

### Rules (.agents/rules/)
Executam enforcement ativo.

Se houver conflito:
→ Rules prevalecem

---

## 🔴 Protocolo de ativação (CRÍTICO)

- Nenhum agente pode se auto-ativar
- Nenhum agente pode trocar de papel sozinho
- Nenhuma execução ocorre sem comando explícito

Autoridade final: usuário

Se não houver comando:
→ NÃO executar
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

---

## Continuidade entre sessões

<<<<<<< HEAD
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
=======
Usar:

resume_session

---

## 🔴 Onboarding de projeto existente (CRÍTICO)

Projetos já iniciados NÃO devem entrar diretamente no fluxo principal.

Deve ser usado:

onboard_existing_project

---

### Quando usar onboarding

- projeto já possui código
- projeto já possui planejamento parcial
- projeto não foi iniciado com a pipeline
- contexto não está formalizado em docs/

---

### Proibido

- usar start_project em projeto existente
- assumir entendimento do projeto sem análise
- iniciar execução sem reconstruir contexto

---

### Objetivo do onboarding

- reconstruir intenção original do projeto
- analisar código existente
- identificar estado atual
- gerar ou corrigir artefatos em docs/
- alinhar o projeto com a pipeline

---

### Resultado esperado

Após onboarding, o projeto deve:

- possuir docs/ consistente
- possuir tasks.md estruturado
- possuir decision_log.md atualizado
- estar pronto para ser retomado pelo Orchestrator

---

## 🔁 Entrada do sistema

Existem dois pontos de entrada válidos:

---

### 1. Projeto novo

Fluxo:

start_project → Discovery → Architect → Executor → Reviewer

---

### 2. Projeto existente

Fluxo:

onboard_existing_project → Orchestrator → fluxo normal
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

---

## Ciclo de vida do projeto

<<<<<<< HEAD
1. Discovery → clarify_intent
2. Architecture → design_architecture
3. Execution → implement_task
4. Review → validate_delivery

---

## Fluxo
=======
1. Discovery → clarify_intent  
2. Architecture → design_architecture  
3. Execution → implement_task  
4. Review → validate_delivery  

---

## Fluxo operacional
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

Discovery → Architect → Executor → Reviewer → Orchestrator

---

<<<<<<< HEAD
## Orchestrator

Responsável por:
=======
## Orquestração

Responsável:
- Orchestrator

Função:
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

- determinar estado
- detectar inconsistências
- decidir próxima ação
<<<<<<< HEAD
=======
- indicar agente
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

---

## Controle de tasks

docs/tasks.md é a única fonte de verdade.

---

## Controle de execução

<<<<<<< HEAD
Fluxo obrigatório:

Executor → Handoff → Reviewer → Orchestrator

Sem qualquer etapa:
=======
- escopo claro
- sem ambiguidade
- confirmação do usuário

---

### Estruturação → Execução

- arquitetura definida
- sem lacunas

---

### Execução → Validação

- implementação concluída
- handoff presente

---

### Validação → Continuação

- aprovado → próxima task
- reprovado → voltar

---

## Controle de tasks (CRÍTICO)

docs/tasks.md é a única fonte de verdade do planejamento.

---

### Regras obrigatórias

- nenhuma task pode ser executada fora de docs/tasks.md
- nenhuma task pode ser criada fora de docs/tasks.md
- nenhuma task pode ser ignorada
- nenhuma task pode ser reordenada sem registro

---

### Relação com artifact interno (Antigravity)

O modelo pode gerar:

- tasks internas
- checklists
- planning auxiliar

Esses artifacts:

- são temporários
- são locais à sessão
- NÃO são fonte de verdade

---

### Regra crítica de alinhamento

Se houver divergência entre:

- docs/tasks.md  
- artifact interno  

→ docs/tasks.md prevalece

---

### Regra de bloqueio

Se o agente detectar que:

- está executando algo fora de docs/tasks.md  
- está seguindo planejamento interno divergente  

→ PARAR  
→ corrigir alinhamento  
→ atualizar docs/tasks.md se necessário  

---

### Regra de alteração de task

Qualquer mudança deve:

1. atualizar docs/tasks.md  
2. registrar em docs/decision_log.md  

---

## Controle de execução

Fluxo obrigatório:

Executor → Handoff → Reviewer → Orchestrator

Se qualquer etapa faltar:
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5
→ BLOQUEAR

---

<<<<<<< HEAD
## Regra final

Se houver dúvida:
→ garantir consistência
=======
## Integração com Rules

Rules garantem:

- leitura obrigatória de contexto
- disciplina de tasks
- bloqueio de execução indevida
- controle de agente

Se Rule bloquear:
→ obedecer

---

## Comportamento em falha

Ambiguidade → Discovery  
Falta de arquitetura → Architect  
Erro → Executor  
Reprovação → corrigir  
Conflito → decision_log.md  

---

## Critério de qualidade

Sistema correto quando:

- execução segue tasks.md
- nenhuma execução ocorre fora do plano
- decisões deixam rastro
- fluxo é respeitado

---

## Regra final

Se houver dúvida entre:

- seguir o planejamento interno do modelo  
- ou seguir docs/tasks.md  

→ seguir docs/tasks.md  
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5

---

## Versão

<<<<<<< HEAD
v2
=======
v4 — com onboarding integrado e pipeline completa
>>>>>>> 49da42c37979f503ae2ddc783a163af3e3d018f5
