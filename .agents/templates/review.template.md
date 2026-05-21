# Review — TASK-XXX

## Identificação

- Task ID: TASK-XXX
- Nome da task:
- Tipo: feature | fix | refactor | docs | infra | test | chore
- Status da revisão: approved | approved_with_reservations | rejected
- Agente responsável: Reviewer
- Responsável humano:
- Branch relacionada:
- Data:

---

## Localização

Este review pertence à task:

```txt
docs/tasks/TASK-XXX-name/review.md
```

Este arquivo registra a validação da entrega feita pelo Executor.

A revisão deve ser baseada em:

```txt
docs/tasks/TASK-XXX-name/scope.md
docs/tasks/TASK-XXX-name/implementation_plan.md
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/decisions.md
docs/project/architecture.md
docs/project/decision_log.md
```

---

## Resumo da entrega revisada

Descreva objetivamente o que foi entregue segundo o handoff.

Referência principal:

```txt
docs/tasks/TASK-XXX-name/handoff.md
```

---

## Arquivos revisados

Liste os arquivos analisados.

### Código

```txt

```

### Documentação da task

```txt

```

### Documentação global consultada

```txt

```

---

## Análise funcional

A task cumpre o objetivo definido em `scope.md`?

Avaliar:

- comportamento esperado;
- critérios de aceite;
- fluxos principais;
- fluxos de erro;
- completude da entrega.

### Resultado

```txt
aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Análise de escopo

A entrega permaneceu dentro do escopo?

Verificar:

- se houve expansão indevida;
- se houve alteração fora da task;
- se algo do escopo ficou incompleto;
- se houve antecipação de tasks futuras.

### Resultado

```txt
aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Análise estrutural

A implementação respeita a arquitetura do projeto?

Referência:

```txt
docs/project/architecture.md
```

Avaliar:

- organização dos arquivos;
- separação de responsabilidades;
- padrões existentes;
- acoplamento indevido;
- criação de soluções paralelas;
- complexidade desnecessária.

### Resultado

```txt
aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Análise de decisões

A entrega respeita decisões já registradas?

Referências:

```txt
docs/project/decision_log.md
docs/tasks/TASK-XXX-name/decisions.md
```

Avaliar:

- conflito com decisões globais;
- decisões locais bem justificadas;
- decisões locais que deveriam virar decisão global;
- decisões implícitas não documentadas.

### Resultado

```txt
aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Análise de segurança

Preencher quando a task tocar autenticação, autorização, dados sensíveis, banco, API, pagamentos, permissões, arquivos, integrações externas ou deploy.

Avaliar:

- exposição de dados sensíveis;
- validação de entrada;
- autenticação;
- autorização;
- secrets hardcoded;
- logs indevidos;
- permissões;
- riscos de abuso;
- impacto em produção.

### Resultado

```txt
não_aplicável | aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Análise de banco de dados

Preencher quando a task tocar schema, migrations, queries, persistência ou integridade de dados.

Avaliar:

- impacto em tabelas;
- migrations;
- compatibilidade;
- integridade;
- rollback;
- dados existentes;
- performance.

### Resultado

```txt
não_aplicável | aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Análise de API

Preencher quando a task tocar endpoints, contratos, payloads, integrações ou autenticação de API.

Avaliar:

- contrato de entrada;
- contrato de saída;
- códigos de resposta;
- erros;
- compatibilidade;
- versionamento;
- validação.

### Resultado

```txt
não_aplicável | aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Análise documental

Verificar se a documentação obrigatória foi preenchida corretamente.

### Checklist

- [ ] `scope.md` existe e está claro
- [ ] `implementation_plan.md` existe e foi seguido ou justificado
- [ ] `handoff.md` existe
- [ ] `handoff.md` contém evidências suficientes
- [ ] `decisions.md` foi atualizado, se necessário
- [ ] decisões globais foram recomendadas ao Orchestrator, se necessário
- [ ] pendências foram registradas
- [ ] sugestões de novas tasks foram separadas do escopo atual

### Resultado

```txt
aprovado | ressalva | reprovado
```

### Observações

```txt

```

---

## Evidências verificadas

Liste as evidências analisadas.

Exemplos:

- comandos executados;
- build;
- testes automatizados;
- validação manual;
- logs;
- prints;
- diff;
- comportamento observado.

```txt

```

---

## Problemas encontrados

Classifique cada problema como:

```txt
bloqueante | ressalva | melhoria | nova_task
```

### Problemas bloqueantes

Impedem aprovação.

```txt

```

### Ressalvas

Permitem aprovação com atenção.

```txt

```

### Melhorias futuras

Não bloqueiam a task atual.

```txt

```

### Sugestões de novas tasks

Trabalhos reais, mas fora do escopo atual.

```txt

```

---

## Correções exigidas

Preencher somente se houver reprovação ou aprovação com ressalvas relevantes.

```txt

```

---

## Recomendação ao Orchestrator

Indique a próxima ação recomendada:

```txt
aprovar_task | retornar_ao_executor | criar_nova_task | promover_decisao_global | atualizar_documentacao_global | preparar_release
```

Justificativa:

```txt

```

---

## Decisão final

Marque apenas uma opção:

- [ ] Aprovado
- [ ] Aprovado com ressalvas
- [ ] Reprovado

---

## Justificativa da decisão

Explique objetivamente o motivo da decisão.

```txt

```

---

## Checklist final do Reviewer

- [ ] Escopo foi verificado
- [ ] Handoff foi analisado
- [ ] Evidências foram verificadas
- [ ] Arquitetura foi considerada
- [ ] Decision log foi considerado
- [ ] Riscos foram avaliados
- [ ] Problemas foram classificados
- [ ] Próxima ação foi recomendada
- [ ] Review está completo o suficiente para o Orchestrator decidir

---

## Regra crítica

Sem handoff suficiente, não aprovar.

Sem evidência mínima, não aprovar.

Se a entrega contradiz arquitetura, segurança ou decisão global, reprovar.

O Reviewer não corrige silenciosamente a entrega.

O Reviewer protege o projeto.