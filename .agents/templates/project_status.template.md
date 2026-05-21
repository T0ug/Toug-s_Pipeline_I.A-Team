# Project Status

Status global do projeto.

Este arquivo deve ser usado em:

```txt
docs/project/project_status.md
```

---

## Finalidade

Este arquivo registra a visão atual do projeto como um todo.

Ele NÃO deve substituir:

```txt
docs/project/backlog.md
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/review.md
docs/tasks/TASK-XXX-name/decisions.md
```

Use este arquivo para responder rapidamente:

- em que fase o projeto está;
- qual task está ativa;
- qual foi a última task concluída;
- qual é o próximo passo;
- quais bloqueios existem;
- quais riscos globais precisam de atenção.

---

## Regra principal

`project_status.md` é visão executiva.

Não é handoff técnico.

Não é backlog completo.

Não é review.

Não é histórico detalhado de implementação.

Detalhes de execução pertencem à pasta da task:

```txt
docs/tasks/TASK-XXX-name/
```

---

# Status Atual

## Visão geral

Resumo curto do estado atual do projeto.

```txt

```

---

## Fase atual

Marcar apenas uma opção principal:

- [ ] Discovery
- [ ] Architecture
- [ ] Planning
- [ ] Execution
- [ ] Review
- [ ] Integration
- [ ] Release preparation
- [ ] Maintenance
- [ ] Blocked

Descrição da fase atual:

```txt

```

---

## Task ativa

```txt
TASK-XXX-name
```

Local da documentação:

```txt
docs/tasks/TASK-XXX-name/
```

Status da task:

```txt
pending | active | blocked | in_review | completed | cancelled
```

Resumo:

```txt

```

---

## Última task concluída

```txt
TASK-XXX-name
```

Local da documentação:

```txt
docs/tasks/TASK-XXX-name/
```

Resumo da conclusão:

```txt

```

Referências:

```txt
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/review.md
```

---

## Próxima task provável

```txt
TASK-XXX-name
```

Local da documentação:

```txt
docs/tasks/TASK-XXX-name/
```

Motivo da prioridade:

```txt

```

---

## Próxima ação recomendada

Selecionar exatamente uma próxima ação:

```txt
continuar_discovery
continuar_architecture
criar_task
executar_task
validar_entrega
corrigir_inconsistencia
atualizar_documentacao
preparar_release
bloquear_fluxo
```

Descrição objetiva:

```txt

```

Agente recomendado:

```txt
Discovery | Architect | Orchestrator | Executor | Reviewer
```

Skill recomendada:

```txt

```

---

# Estado do Backlog

O backlog completo fica em:

```txt
docs/project/backlog.md
```

Esta seção deve conter apenas um resumo.

## Resumo por status

```txt
pending:
active:
blocked:
in_review:
completed:
cancelled:
```

---

## Tasks bloqueadas

Liste apenas tasks bloqueadas relevantes.

```txt
- TASK-XXX-name — motivo do bloqueio
```

---

## Tasks em review

```txt
- TASK-XXX-name — aguardando validação
```

---

# Bloqueios

Liste bloqueios globais que impedem avanço.

```txt
- 
```

Para cada bloqueio, indicar:

```txt
Bloqueio:
Impacto:
Responsável:
Ação necessária:
```

---

# Riscos Globais

Liste riscos relevantes para o projeto como um todo.

Classificação sugerida:

```txt
baixo | médio | alto
```

## Riscos

```txt
- Risco:
  Nível:
  Impacto:
  Mitigação:
```

---

# Inconsistências Documentais

Registrar inconsistências encontradas entre:

```txt
docs/project/backlog.md
docs/project/project_status.md
docs/project/decision_log.md
docs/tasks/TASK-XXX-name/
```

## Inconsistências atuais

```txt
- 
```

## Ação necessária

```txt

```

---

# Decisões Pendentes

Decisões locais que talvez precisem ser promovidas para:

```txt
docs/project/decision_log.md
```

## Pendentes de avaliação

```txt
- TASK-XXX-name — decisão a avaliar
```

---

# Documentação Global

Status dos principais documentos globais.

```txt
docs/project/vision.md          — ok | ausente | desatualizado
docs/project/scope.md           — ok | ausente | desatualizado
docs/project/architecture.md    — ok | ausente | desatualizado
docs/project/database.md        — ok | ausente | desatualizado | não aplicável
docs/project/api.md             — ok | ausente | desatualizado | não aplicável
docs/project/security.md        — ok | ausente | desatualizado | não aplicável
docs/project/backlog.md         — ok | ausente | desatualizado
docs/project/decision_log.md    — ok | ausente | desatualizado
```

Observações:

```txt

```

---

# Estado Técnico Geral

Resumo técnico de alto nível.

## Backend

```txt

```

## Frontend

```txt

```

## Banco de dados

```txt

```

## Infra / Deploy

```txt

```

## Integrações externas

```txt

```

## Segurança

```txt

```

---

# Última Atualização

- Data:
- Atualizado por:
- Motivo da atualização:
- Task relacionada:

---

# Regras de Atualização

Atualizar este arquivo quando:

- uma task mudar de status;
- uma task for concluída;
- uma task entrar em review;
- houver bloqueio relevante;
- houver mudança de fase;
- houver risco global;
- houver decisão pendente de promoção;
- houver preparação de release;
- houver inconsistência documental.

---

## Não registrar aqui

Não registrar neste arquivo:

- detalhes extensos de implementação;
- lista completa de arquivos alterados;
- explicação técnica longa da entrega;
- review detalhado;
- decisões locais da task;
- logs completos;
- evidências detalhadas.

Essas informações pertencem a:

```txt
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/review.md
docs/tasks/TASK-XXX-name/decisions.md
```

---

# Regra crítica

Se este arquivo contradizer o backlog, handoff ou review da task:

```txt
→ bloquear continuidade
→ acionar Orchestrator
→ corrigir inconsistência antes de executar nova task
```

O `project_status.md` deve refletir o estado real do projeto, não uma intenção desatualizada.