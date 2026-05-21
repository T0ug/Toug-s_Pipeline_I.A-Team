# Architecture

Documento de arquitetura global do projeto.

Este arquivo deve ser usado em:

```txt
docs/project/architecture.md
```

---

## Finalidade

Este documento registra a visão estrutural do sistema.

Ele deve explicar:

- como o sistema é organizado;
- quais são os principais módulos;
- como os componentes se relacionam;
- quais padrões técnicos devem ser seguidos;
- quais limites arquiteturais não devem ser violados.

Este arquivo NÃO deve conter detalhes extensos de execução de tasks.

Detalhes de execução pertencem a:

```txt
docs/tasks/TASK-XXX-name/
```

---

## Relação com outros documentos

Este arquivo deve se manter coerente com:

```txt
docs/project/vision.md
docs/project/scope.md
docs/project/database.md
docs/project/api.md
docs/project/security.md
docs/project/decision_log.md
docs/project/backlog.md
```

Use este documento para visão arquitetural geral.

Use documentos específicos para detalhes:

```txt
docs/project/database.md  → estrutura de banco, entidades, migrations
docs/project/api.md       → contratos, endpoints, payloads
docs/project/security.md  → autenticação, autorização, proteção de dados
docs/project/decision_log.md → decisões globais e permanentes
```

---

# Visão geral

## Propósito do sistema

Descreva o objetivo central do sistema.

```txt

```

---

## Resumo arquitetural

Explique a arquitetura em alto nível.

Exemplo:

```txt
Frontend → Backend/API → Banco de Dados → Integrações externas
```

Descrição:

```txt

```

---

## Tipo de aplicação

Marque o que se aplica:

- [ ] SaaS
- [ ] Aplicação web interna
- [ ] Aplicação desktop
- [ ] Aplicação mobile
- [ ] API standalone
- [ ] Monorepo
- [ ] Microserviços
- [ ] Aplicação híbrida
- [ ] Outro:

---

# Componentes principais

## Frontend

### Responsabilidades

Descreva o papel do frontend.

```txt

```

### Tecnologias

```txt

```

### Principais áreas/telas

```txt
- 
```

### Regras arquiteturais do frontend

```txt
- 
```

---

## Backend

### Responsabilidades

Descreva o papel do backend.

```txt

```

### Tecnologias

```txt

```

### Principais módulos

```txt
- 
```

### Regras arquiteturais do backend

```txt
- 
```

---

## Banco de dados

Resumo geral.

Detalhes completos devem estar em:

```txt
docs/project/database.md
```

### Tipo de banco

```txt

```

### Entidades principais

```txt
- 
```

### Regras gerais

```txt
- 
```

---

## APIs

Resumo geral.

Contratos completos devem estar em:

```txt
docs/project/api.md
```

### Estilo de API

Marcar o que se aplica:

- [ ] REST
- [ ] GraphQL
- [ ] RPC
- [ ] Webhook
- [ ] Eventos/filas
- [ ] Outro:

### Regras gerais de API

```txt
- 
```

---

## Integrações externas

Liste serviços externos relevantes.

```txt
- Serviço:
  Finalidade:
  Tipo de integração:
  Risco:
```

---

## Autenticação e autorização

Resumo geral.

Detalhes completos devem estar em:

```txt
docs/project/security.md
```

### Modelo de autenticação

```txt

```

### Modelo de autorização

```txt

```

### Regras gerais

```txt
- 
```

---

# Fluxos principais

Descreva os fluxos centrais do sistema.

## Fluxo 1 — Nome do fluxo

```txt
Usuário → Frontend → Backend → Banco/Integração → Resposta
```

Descrição:

```txt

```

---

## Fluxo 2 — Nome do fluxo

```txt

```

Descrição:

```txt

```

---

# Estrutura de diretórios

Descreva a estrutura principal do projeto.

```txt
/
├── frontend/
├── backend/
├── database/
├── docs/
│   ├── project/
│   ├── tasks/
│   ├── releases/
│   └── archive/
└── ...
```

---

## Responsabilidade dos diretórios

```txt
Diretório:
Responsabilidade:
Observações:
```

---

# Padrões arquiteturais

## Separação de responsabilidades

Defina como as responsabilidades devem ser separadas.

```txt

```

---

## Organização de módulos

Defina como módulos devem ser criados ou agrupados.

```txt

```

---

## Regras de dependência

Defina o que pode depender de quê.

Exemplo:

```txt
Frontend não acessa banco diretamente.
Backend concentra regra de negócio.
Módulo de pagamento não deve depender de componentes visuais.
```

Regras:

```txt
- 
```

---

## Regras de estado

Descreva onde o estado da aplicação deve ficar.

```txt

```

---

## Regras de erro

Descreva padrão geral de tratamento de erros.

```txt

```

---

## Regras de logs

Descreva padrão geral de logs.

```txt

```

---

# Decisões técnicas consolidadas

Resumo das principais decisões arquiteturais.

As decisões completas devem estar em:

```txt
docs/project/decision_log.md
```

## Decisões relevantes

```txt
- DEC-XXX — Título:
  Resumo:
  Impacto arquitetural:
```

---

# Restrições técnicas

Liste limites obrigatórios.

```txt
- 
```

Exemplos:

- não usar determinada tecnologia;
- não acessar banco diretamente pelo frontend;
- não armazenar segredo no cliente;
- não criar endpoint sem validação;
- não alterar schema sem migration;
- não introduzir dependência sem justificativa.

---

# Regras para novas implementações

Toda nova task deve respeitar este documento.

Antes de implementar, o Executor deve verificar:

```txt
docs/project/architecture.md
docs/project/decision_log.md
docs/tasks/TASK-XXX-name/scope.md
docs/tasks/TASK-XXX-name/implementation_plan.md
```

Se uma task contradizer a arquitetura:

```txt
→ parar
→ registrar conflito
→ acionar Orchestrator ou Architect
```

---

# Regras para mudanças arquiteturais

Mudanças arquiteturais não devem ser feitas silenciosamente dentro de uma task comum.

Se uma task exigir mudança arquitetural:

1. registrar a necessidade em `docs/tasks/TASK-XXX-name/decisions.md`;
2. acionar Orchestrator;
3. acionar Architect, se necessário;
4. registrar decisão global em `docs/project/decision_log.md`;
5. atualizar este arquivo.

---

# Riscos arquiteturais

Liste riscos técnicos relevantes.

```txt
- Risco:
  Nível: baixo | médio | alto
  Impacto:
  Mitigação:
```

---

# Dívidas técnicas conhecidas

Liste dívidas técnicas estruturais.

```txt
- Dívida:
  Impacto:
  Quando revisar:
  Task relacionada:
```

---

# Pontos de atenção para Reviewer

O Reviewer deve reprovar ou aprovar com ressalvas entregas que:

- contradizem esta arquitetura;
- criam padrão paralelo sem justificativa;
- misturam responsabilidades;
- acessam recursos por caminho proibido;
- ignoram decisões globais;
- introduzem dependências sem necessidade;
- expandem escopo arquitetural dentro de task comum.

---

# Atualização deste documento

Atualizar este arquivo quando houver:

- mudança estrutural;
- novo módulo relevante;
- alteração de padrão técnico;
- mudança em autenticação/autorização;
- mudança relevante em banco, API ou deploy;
- decisão global aprovada que afete arquitetura.

---

## Última atualização

- Data:
- Atualizado por:
- Motivo:
- Task relacionada:
- Decisão relacionada:

---

# Regra crítica

Este documento é fonte de verdade arquitetural.

Se o código, uma task ou uma decisão local contradizer este arquivo:

```txt
→ bloquear continuidade
→ acionar Orchestrator
→ avaliar necessidade de Architect
→ registrar decisão global antes de alterar a arquitetura
```