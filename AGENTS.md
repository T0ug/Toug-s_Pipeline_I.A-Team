# AGENTS.md

This repository uses a Codex-native, task-scoped development pipeline.

These instructions are always active when this file is installed at the repository root.

## Source Of Truth

Chat is not the project source of truth.

Use repository artifacts:

```txt
docs/project/   permanent project memory
docs/tasks/     task execution memory
docs/releases/  delivery snapshots
docs/archive/   inactive historical material
```

Canonical project files:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
```

Canonical task folder:

```txt
docs/tasks/TASK-XXX-name/
  scope.md
  implementation_plan.md
  handoff.md
  review.md
  decisions.md
```

## Before Code Changes

Before implementing a feature, fix, refactor, migration, or other code change:

1. Identify the active task from the user request, `docs/project/backlog.md`, or `docs/project/project_status.md`.
2. Read the canonical project files when they exist.
3. Locate or create the matching `docs/tasks/TASK-XXX-name/` folder.
4. Read `scope.md` and `implementation_plan.md`.
5. Read existing `handoff.md`, `review.md`, and `decisions.md` when present.
6. Implement only the approved task scope.

If required context is missing:

- For ambiguous, risky, architectural, security-sensitive, or broad work: stop and ask.
- For small explicit fixes: proceed conservatively, document the missing context in `handoff.md`, and avoid expanding scope.

## Implementation Rules

Codex must:

- keep changes narrow and traceable;
- follow existing architecture and local code patterns;
- avoid unrelated refactors;
- avoid modifying global project docs with task execution details;
- record task-specific decisions in `docs/tasks/TASK-XXX-name/decisions.md`;
- update `docs/tasks/TASK-XXX-name/handoff.md` after implementation.

Codex must not:

- mix unrelated tasks in one execution;
- rewrite architecture silently;
- promote task-local decisions to global docs unless they affect the whole project;
- mark work complete without handoff evidence;
- treat branch names as documentation identity.

## Review Rules

For review requests:

1. Read the canonical project files.
2. Read the task folder.
3. Validate scope adherence, architecture consistency, security impact, side effects, code quality, validation evidence, and documentation completeness.
4. Write results to `docs/tasks/TASK-XXX-name/review.md`.

Review outcomes:

```txt
approved
approved_with_notes
rejected
```

## Decision Rules

Use task decisions for local implementation choices:

```txt
docs/tasks/TASK-XXX-name/decisions.md
```

Use global decision log only for decisions that affect:

- architecture;
- security;
- database design;
- API contracts;
- deployment;
- project-wide standards;
- multiple systems;
- long-term maintenance.

```txt
docs/project/decision_log.md
```

## Codex Skills

Use the skills in `.agents/skills/` when their descriptions match the request.

Primary skills:

- `pipeline-router`: default entrypoint for status, planning, task creation, implementation, review, validation, onboarding, and next-action decisions.
- `execute-task`: implement a defined task using this pipeline.
- `review-delivery`: validate a completed task.
- `resume-session`: reconstruct state before continuing unclear or resumed work.
- `onboard-existing-project`: align an existing project with this pipeline.
- `structure-project`: create the initial docs structure for a new project.

For natural-language pipeline requests, use `pipeline-router` first. The user should not need to name skills, scripts, task paths, or workflow order.

When the user asks for the current pipeline, project, or task state, route through `pipeline-router`, use `resume-session`, and reconstruct state from repository docs before answering.

## Deterministic Scripts

Prefer scripts over hand-created boilerplate when they are available:

```powershell
./.agents/scripts/pipeline.ps1 status -Root .
./.agents/scripts/init_project.ps1 -Root .
./.agents/scripts/init_task.ps1 -Root . -Id TASK-001 -Name "task name"
./.agents/scripts/validate_project.ps1 -Root .
./.agents/scripts/validate_task.ps1 -Root . -Task TASK-001 -Stage ready
./.agents/scripts/status_pipeline.ps1 -Root .
```

Use scripts to create repeatable structure and to verify pipeline contracts. If a script fails, treat the failure as a blocker unless the user explicitly chooses to proceed.

## Safety

If repository state and requested work conflict:

1. stop before making broad changes;
2. explain the conflict;
3. update task docs only when the resolution is clear;
4. ask the user when the decision changes scope, architecture, or risk.

## Completion

An implementation task is complete only when:

- code changes are finished;
- relevant validation was run or explicitly skipped with reason;
- `handoff.md` records changed files, behavior, decisions, evidence, risks, and next steps;
- any global documentation updates are justified.
