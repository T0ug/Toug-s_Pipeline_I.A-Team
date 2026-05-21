# Handoff — TASK-XXX

## Identificação

- Task ID: TASK-XXX
- Nome da task:
- Tipo: feature | fix | refactor | docs | infra | test | chore
- Status da entrega: complete | partial | blocked
- Agente responsável: Executor
- Responsável humano:
- Branch relacionada:
- Data:

---

## Localização

Este handoff pertence à task:

```txt
docs/tasks/TASK-XXX-name/handoff.md
```

Este arquivo registra a execução da task e deve conter informação suficiente para que outro agente ou desenvolvedor consiga entender o que foi feito sem depender do histórico do chat.

---

## Objetivo da task

Descreva de forma objetiva o que esta task deveria entregar.

Referência principal:

```txt
docs/tasks/TASK-XXX-name/scope.md
```

---

## Escopo executado

Descreva exatamente o que foi implementado.

Inclua:

- funcionalidades criadas;
- correções realizadas;
- partes do sistema afetadas;
- limites respeitados;
- o que foi deixado fora do escopo.

---

## Escopo não executado

Liste explicitamente o que NÃO foi feito.

Use esta seção para evitar falsa impressão de conclusão total.

Exemplo:

- Não foi alterado o fluxo de autenticação;
- Não foi criada migration;
- Não foi implementado tratamento avançado de erro;
- Não foi feita integração com produção.

---

## Arquivos afetados

Liste todos os arquivos relevantes.

### Criados

```txt

```

### Modificados

```txt

```

### Removidos

```txt

```

### Apenas consultados

```txt

```

---

## Resumo técnico da implementação

Explique como a solução foi implementada.

Foque em funcionamento real, não em narrativa longa.

Inclua:

- módulos alterados;
- fluxo principal;
- regras aplicadas;
- integrações envolvidas;
- dados lidos ou gravados;
- comportamento esperado.

---

## Lógica implementada

Descreva a lógica de forma objetiva.

Exemplo de estrutura:

```txt
1. Usuário executa determinada ação.
2. Sistema valida determinada condição.
3. Backend processa determinada regra.
4. Resultado é persistido ou retornado.
5. Interface exibe o estado final.
```

---

## Decisões tomadas durante a execução

Liste decisões específicas desta task.

Se houver decisões locais, elas também devem ser registradas em:

```txt
docs/tasks/TASK-XXX-name/decisions.md
```

### Decisões locais

- 

### Decisões que talvez precisem ser promovidas para o decision log global

- 

Promover para:

```txt
docs/project/decision_log.md
```

apenas se a decisão afetar:

- arquitetura;
- segurança;
- banco de dados;
- contratos de API;
- deploy;
- padrões globais;
- múltiplas áreas do sistema;
- manutenção de longo prazo.

---

## Evidências da entrega

Esta seção é obrigatória.

Sem evidência suficiente, a entrega não pode ser validada.

Inclua pelo menos um dos seguintes:

- comandos executados;
- resultado de build;
- resultado de testes;
- validação manual;
- logs relevantes;
- prints, quando aplicável;
- diff resumido;
- descrição objetiva do comportamento observado.

### Comandos executados

```bash

```

### Resultado observado

```txt

```

### Evidência manual

```txt

```

---

## Validação realizada

Descreva como a entrega foi validada.

Inclua:

- ambiente usado;
- passos de teste;
- comportamento esperado;
- comportamento observado;
- erros encontrados;
- correções realizadas.

### Passos de validação

1. 
2. 
3. 

### Resultado

```txt

```

---

## Impacto no sistema

Descreva possíveis impactos da entrega.

Inclua:

- módulos afetados;
- fluxos impactados;
- risco de regressão;
- impacto em banco de dados;
- impacto em API;
- impacto em segurança;
- impacto em deploy;
- impacto em próximas tasks.

---

## Riscos conhecidos

Liste riscos que ainda existem após a implementação.

Classifique, se possível:

```txt
baixo | médio | alto
```

### Riscos

- 

---

## Limitações conhecidas

Liste limitações da entrega.

Exemplo:

- solução parcial;
- validação apenas manual;
- ausência de teste automatizado;
- dependência de ajuste futuro;
- comportamento ainda não coberto.

---

## Pendências

Liste o que ficou pendente.

Separe pendências internas da task e trabalhos que devem virar novas tasks.

### Pendências dentro da task

- 

### Sugestões de novas tasks

- 

---

## Documentação atualizada

Marque o que foi atualizado:

- [ ] `docs/tasks/TASK-XXX-name/handoff.md`
- [ ] `docs/tasks/TASK-XXX-name/decisions.md`
- [ ] `docs/project/backlog.md`
- [ ] `docs/project/project_status.md`
- [ ] `docs/project/decision_log.md`
- [ ] `docs/project/architecture.md`
- [ ] `docs/project/database.md`
- [ ] `docs/project/api.md`
- [ ] `docs/project/security.md`

Observação:

Arquivos em `docs/project/` só devem ser atualizados quando houver impacto global.

---

## Checklist de conclusão do Executor

- [ ] Escopo da task foi respeitado
- [ ] Não houve expansão silenciosa de escopo
- [ ] Arquivos afetados foram listados
- [ ] Implementação foi resumida
- [ ] Evidências foram incluídas
- [ ] Validação foi descrita
- [ ] Riscos foram documentados
- [ ] Pendências foram documentadas
- [ ] Decisões locais foram registradas, se houver
- [ ] Sugestões de novas tasks foram separadas do escopo atual
- [ ] Entrega está pronta para revisão

---

## Próxima ação sugerida

Indique a próxima ação recomendada:

```txt
validar_entrega | corrigir_pendencias | abrir_nova_task | atualizar_documentacao | preparar_release
```

Descreva brevemente:

```txt

```

---

## Status final do handoff

Marque apenas uma opção:

- [ ] Completo
- [ ] Parcial
- [ ] Bloqueado

---

## Observações finais

Qualquer informação adicional relevante.

---

## Regra crítica

Este handoff deve conter informação suficiente para:

- outro agente continuar o trabalho sem contexto do chat;
- o Reviewer validar a entrega;
- o Orchestrator atualizar o estado do projeto;
- a task ser retomada no futuro sem perda de contexto.

Se isso não for possível, o handoff está incompleto.