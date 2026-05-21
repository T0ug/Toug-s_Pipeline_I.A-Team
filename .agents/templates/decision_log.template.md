# Project Decision Log

Registro de decisões globais relevantes do projeto.

Este arquivo deve ser usado em:

```txt
docs/project/decision_log.md
```

---

## Finalidade

Este arquivo registra decisões permanentes ou estruturais que afetam o projeto como um todo.

Não use este arquivo para decisões pequenas, locais ou específicas de uma única task.

Decisões locais devem ser registradas em:

```txt
docs/tasks/TASK-XXX-name/decisions.md
```

---

## Quando registrar uma decisão global

Registrar aqui apenas decisões que afetem:

- arquitetura;
- segurança;
- banco de dados;
- contratos de API;
- deploy;
- padrões globais;
- integrações centrais;
- organização estrutural do projeto;
- manutenção de longo prazo;
- múltiplas áreas do sistema.

---

## Quando NÃO registrar aqui

Não registrar neste arquivo:

- ajustes pequenos de implementação;
- decisões provisórias de uma task;
- escolhas locais sem impacto global;
- detalhes de execução;
- pendências;
- bugs pontuais;
- preferências de código sem consequência arquitetural.

Esses casos pertencem a:

```txt
docs/tasks/TASK-XXX-name/decisions.md
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/review.md
```

---

# Decisões

## [YYYY-MM-DD] — Título da decisão

### ID

DEC-XXX

---

### Status

Escolher uma opção:

```txt
proposed | accepted | superseded | deprecated | rejected
```

---

### Escopo da decisão

Indique o tipo de impacto:

- [ ] Arquitetura
- [ ] Segurança
- [ ] Banco de dados
- [ ] API
- [ ] Deploy
- [ ] Integração externa
- [ ] Padrão global
- [ ] Produto/negócio
- [ ] Processo/pipeline
- [ ] Outro:

---

### Contexto

Explique a situação que levou à decisão.

Inclua:

- problema identificado;
- limitação existente;
- risco percebido;
- necessidade do projeto;
- relação com tasks ou decisões anteriores.

---

### Decisão

Descreva objetivamente o que foi decidido.

A decisão deve ser clara o suficiente para orientar futuras implementações.

---

### Motivo

Explique por que esta decisão foi tomada.

Inclua:

- vantagens;
- riscos evitados;
- restrições consideradas;
- impacto esperado;
- razão para não manter o caminho anterior.

---

### Alternativas consideradas

Liste alternativas avaliadas.

#### Alternativa A

Descrição:

Motivo para não escolher:

#### Alternativa B

Descrição:

Motivo para não escolher:

#### Alternativa C

Descrição:

Motivo para não escolher:

---

### Impacto no projeto

Descreva o que muda com esta decisão.

Avaliar impacto em:

- arquitetura;
- backend;
- frontend;
- banco de dados;
- API;
- segurança;
- deploy;
- documentação;
- próximas tasks;
- manutenção futura.

---

### Tasks relacionadas

Liste tasks relacionadas:

```txt
TASK-XXX-name
TASK-YYY-name
```

---

### Arquivos ou áreas afetadas

Liste arquivos, diretórios ou módulos afetados:

```txt

```

---

### Consequências práticas

Descreva como agentes e desenvolvedores devem agir a partir desta decisão.

Exemplo:

- Novas APIs devem seguir determinado padrão;
- Migrations devem respeitar determinada regra;
- O frontend não deve acessar diretamente determinado recurso;
- Autenticação deve passar por determinado módulo.

---

### Critérios de revisão futura

Defina quando esta decisão deve ser revista.

Exemplo:

- quando houver aumento de escala;
- quando entrar novo módulo;
- quando houver problema de performance;
- quando a integração externa mudar;
- quando a decisão bloquear evolução do produto.

---

### Decisões substituídas

Se esta decisão substitui uma anterior, registrar:

```txt
DEC-XXX — Título da decisão substituída
```

Se não substitui nenhuma:

```txt
Nenhuma.
```

---

### Observações

Qualquer detalhe adicional relevante.

---

## Regra crítica

Uma decisão registrada neste arquivo passa a orientar todo o projeto.

Se uma implementação futura contradizer uma decisão global:

```txt
→ parar
→ registrar conflito
→ acionar Orchestrator ou Architect
```

Não ignorar decisões globais silenciosamente.