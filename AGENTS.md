# AGENTS.md

# Purpose

This repository uses a structured AI-assisted development pipeline.

The goal is NOT only code generation.

The goal is:
- controlled execution
- architectural consistency
- traceability
- reproducibility
- task isolation
- reviewability
- safe collaboration between humans and AI agents

This repository is designed for multi-developer and multi-agent collaboration.

AI agents must follow the pipeline rules strictly.

---

# Core Philosophy

The project is divided into:

```txt
1. Permanent project memory
2. Task execution memory
3. Release history
```

Correct mental model:

```txt
Branch = temporary implementation vehicle
Task = historical unit of work
Project docs = permanent project memory
Release docs = delivery snapshot
```

Branches are temporary.

Tasks are historical.

Never organize documentation by branch name.

Always organize documentation by task identity.

---

# Documentation Structure

```txt
docs/
├── project/
│   ├── vision.md
│   ├── scope.md
│   ├── architecture.md
│   ├── database.md
│   ├── api.md
│   ├── security.md
│   ├── project_status.md
│   ├── decision_log.md
│   └── backlog.md
│
├── tasks/
│   ├── TASK-001-example/
│   │   ├── scope.md
│   │   ├── implementation_plan.md
│   │   ├── handoff.md
│   │   ├── review.md
│   │   └── decisions.md
│
├── releases/
│   └── v0.1.0.md
│
└── archive/
```

---

# Documentation Rules

## docs/project/

Represents permanent project memory.

Contains:
- architecture
- database standards
- API contracts
- security decisions
- global scope
- permanent decisions

These files must NOT be modified casually.

Changes must be intentional and justified.

---

## docs/tasks/

Represents isolated task execution memory.

Each task must have its own folder.

All implementation evidence belongs here.

Task folders prevent:
- merge conflicts
- mixed handoffs
- context corruption
- concurrent overwrite issues

---

## docs/releases/

Represents delivery snapshots.

Release documents summarize:
- completed tasks
- migrations
- deployment notes
- risks
- important changes

---

# Mandatory Workflow

Before implementing ANY task:

1. Read:
   - docs/project/project_status.md
   - docs/project/architecture.md
   - docs/project/decision_log.md
   - docs/project/backlog.md

2. Locate or create the task folder:

```txt
docs/tasks/TASK-XXX-name/
```

3. Read task documents:
   - scope.md
   - implementation_plan.md
   - previous handoff/review if they exist

4. Only then begin implementation.

---

# Implementation Rules

AI agents MUST:

- stay inside task scope
- avoid unrelated modifications
- avoid architectural rewrites
- avoid broad refactors unless explicitly requested
- document decisions
- generate handoff evidence
- keep changes minimal and traceable

AI agents MUST NOT:

- redefine architecture autonomously
- silently modify unrelated systems
- skip documentation
- bypass review
- create hidden side effects
- modify global docs unnecessarily

---

# Pull Request Philosophy

One task = one Pull Request.

PRs should be:
- small
- reviewable
- isolated
- traceable

Avoid:
- giant mixed PRs
- unrelated modifications
- architecture rewrites inside feature PRs

---

# Handoff Requirements

Every completed implementation MUST generate:

```txt
docs/tasks/TASK-XXX/handoff.md
```

The handoff must contain:
- what was implemented
- files modified
- important decisions
- validation evidence
- risks
- pending issues
- next recommended actions

Code without handoff is considered incomplete.

---

# Review Requirements

Every task review MUST generate:

```txt
docs/tasks/TASK-XXX/review.md
```

The review must validate:
- scope adherence
- architecture consistency
- security
- side effects
- code quality
- documentation completeness

---

# Decision Rules

Task-level decisions belong in:

```txt
docs/tasks/TASK-XXX/decisions.md
```

Permanent architectural decisions belong in:

```txt
docs/project/decision_log.md
```

Promote decisions to global decision log ONLY if they:
- affect architecture
- affect security
- affect standards
- affect multiple systems
- create long-term constraints

---

# Git Workflow

Recommended workflow:

```bash
git checkout main
git pull origin main
git checkout -b feat/TASK-XXX-name
```

Never push directly to main.

All changes must go through Pull Requests.

---

# Collaboration Rules

This repository is designed for simultaneous human and AI collaboration.

To reduce conflicts:

- keep PRs small
- isolate tasks
- avoid editing unrelated files
- avoid modifying global docs unless necessary
- split large systems into modular files
- document everything important

---

# AI Agent Behavior

AI agents should behave like disciplined engineering collaborators.

The objective is not maximum code generation.

The objective is controlled, auditable and maintainable evolution of the project.

Every implementation must leave evidence.