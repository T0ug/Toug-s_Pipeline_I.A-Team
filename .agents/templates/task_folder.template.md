# Task Folder Template

Este template define a estrutura mínima obrigatória para criação de uma nova task.

Cada task deve possuir sua própria pasta em:

```txt
docs/tasks/TASK-XXX-name/
```

Exemplo:

```txt
docs/tasks/TASK-014-google-login/
```

---

## Princípio

Tasks são unidades históricas de trabalho.

Branches são veículos temporários de implementação.

Não organize documentação por branch.

Organize por task.

---

## Estrutura obrigatória da task

Ao criar uma nova task, gerar a seguinte estrutura:

```txt
docs/tasks/TASK-XXX-name/
  scope.md
  implementation_plan.md
  handoff.md
  review.md
  decisions.md
```

---

# 1. scope.md

Criar o arquivo:

```txt
docs/tasks/TASK-XXX-name/scope.md
```

Com o seguinte conteúdo:

```md
# TASK-XXX — Nome da Task

## Identificação

- ID: TASK-XXX
- Nome:
- Tipo: feature | fix | refactor | docs | infra | test | chore
- Status: pending | active | blocked | in_review | completed | cancelled
- Responsável:
- Branch sugerida:
- Criada em:
- Atualizada em:

---

## Objetivo

Descreva claramente o que esta task deve alcançar.

A task deve ter um resultado verificável.

---

## Contexto

Explique:

- onde esta task se encaixa no projeto;
- qual problema ela resolve;
- qual dor ou necessidade motivou a task;
- relação com tasks anteriores;
- relação com decisões já registradas.

---

## Escopo

Defina exatamente o que deve ser feito.

Use lista objetiva.

Exemplo:

- Criar endpoint X;
- Ajustar componente Y;
- Validar campo Z;
- Registrar erro em determinado fluxo.

---

## Fora de escopo

Defina explicitamente o que NÃO deve ser feito.

Isto é obrigatório para evitar vazamento de escopo.

Exemplo:

- Não alterar autenticação;
- Não refatorar módulo inteiro;
- Não modificar schema do banco;
- Não alterar layout fora da tela X.

---

## Critérios de aceite

A task só pode ser considerada concluída se atender aos critérios abaixo:

- [ ] 
- [ ] 
- [ ] 

---

## Entradas necessárias

Liste tudo que a task depende:

- arquivos existentes;
- artefatos em `docs/project/`;
- decisões anteriores;
- dados necessários;
- APIs;
- tabelas;
- componentes;
- credenciais ou variáveis de ambiente, se aplicável.

---

## Dependências

Liste dependências formais:

- TASK-XXX;
- decisão global específica;
- módulo específico;
- endpoint específico;
- migration específica.

---

## Restrições

Defina limites obrigatórios:

- tecnologias obrigatórias;
- padrões a seguir;
- decisões que não podem ser alteradas;
- arquivos que não devem ser modificados;
- cuidados de segurança;
- limitações de performance;
- limitações de compatibilidade.

---

## Impacto esperado no sistema

Descreva:

- partes afetadas;
- possíveis efeitos colaterais;
- integrações impactadas;
- risco de regressão;
- necessidade de atualização de documentação global.

---

## Evidências esperadas

Informe quais evidências devem ser entregues no handoff:

- comandos executados;
- testes automatizados;
- validação manual;
- prints;
- logs;
- comportamento esperado;
- comparação antes/depois.

---

## Observações

Informações adicionais relevantes.
```

---

# 2. implementation_plan.md

Criar o arquivo:

```txt
docs/tasks/TASK-XXX-name/implementation_plan.md
```

Com o seguinte conteúdo:

```md
# Implementation Plan — TASK-XXX

## Objetivo técnico

Explique a abordagem técnica para cumprir o escopo da task.

---

## Leitura obrigatória antes de implementar

Antes de executar, ler:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
docs/tasks/TASK-XXX-name/scope.md
```

Se aplicável, também ler:

```txt
docs/project/database.md
docs/project/api.md
docs/project/security.md
docs/project/scope.md
docs/project/vision.md
```

---

## Estratégia de implementação

Descreva a abordagem sugerida.

Não escrever código detalhado aqui.

Foque em:

- ordem de execução;
- arquivos prováveis;
- módulos afetados;
- cuidados necessários;
- integrações;
- riscos.

---

## Passos propostos

- [ ] Passo 1
- [ ] Passo 2
- [ ] Passo 3
- [ ] Passo 4

---

## Arquivos provavelmente afetados

Liste os arquivos ou diretórios esperados:

```txt

```

---

## Arquivos que não devem ser alterados

Liste arquivos ou áreas protegidas, se houver:

```txt

```

---

## Riscos técnicos

- 
- 
- 

---

## Plano de validação

Descreva como validar a task:

- comando de build;
- comando de teste;
- validação manual;
- fluxo esperado;
- logs esperados;
- comportamento em caso de erro.

---

## Critério para encerrar implementação

A implementação só pode ser encerrada quando:

- [ ] escopo foi cumprido;
- [ ] critérios de aceite foram atendidos;
- [ ] validação mínima foi executada;
- [ ] handoff foi preenchido;
- [ ] decisões locais foram registradas, se houver;
- [ ] pendências foram documentadas.
```

---

# 3. handoff.md

Criar o arquivo:

```txt
docs/tasks/TASK-XXX-name/handoff.md
```

Com o seguinte conteúdo inicial:

```md
# Handoff — TASK-XXX

Status: not_started

Este arquivo deve ser preenchido pelo Executor após a implementação.

Não considerar a task concluída sem handoff completo.
```

---

# 4. review.md

Criar o arquivo:

```txt
docs/tasks/TASK-XXX-name/review.md
```

Com o seguinte conteúdo inicial:

```md
# Review — TASK-XXX

Status: pending

Este arquivo deve ser preenchido pelo Reviewer após a entrega do Executor.

Resultado possível:

- approved
- approved_with_reservations
- rejected
```

---

# 5. decisions.md

Criar o arquivo:

```txt
docs/tasks/TASK-XXX-name/decisions.md
```

Com o seguinte conteúdo inicial:

```md
# Decisions — TASK-XXX

Este arquivo registra decisões locais da task.

Decisões locais não devem ser registradas diretamente em:

```txt
docs/project/decision_log.md
```

Promover para o decision log global apenas se a decisão afetar:

- arquitetura;
- segurança;
- banco de dados;
- contratos de API;
- deploy;
- padrões globais;
- múltiplas áreas do sistema;
- manutenção de longo prazo.

---

## Decisões locais

Nenhuma decisão registrada ainda.
```

---

## Regra final

Uma task só está pronta para execução quando existirem, no mínimo:

```txt
docs/tasks/TASK-XXX-name/scope.md
docs/tasks/TASK-XXX-name/implementation_plan.md
```

Uma task só pode ser considerada concluída quando existirem e estiverem preenchidos:

```txt
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/review.md
```