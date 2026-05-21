---
name: resume-session
description: Use when Codex is continuing work after a new, unclear, resumed, or interrupted session, or when the user asks "what is the current pipeline/project/task state?", "qual o estado atual da pipeline?", "onde paramos?", "qual task está ativa?", or similar status questions. Reconstruct project state from docs/project and docs/tasks before acting.
---

# Resume Session

Use this workflow before continuing work when session state is unclear.

For status questions, answer by reconstructing state from files. Do not rely on chat memory.

## Status Script

When practical, run:

```powershell
./.agents/scripts/status_pipeline.ps1 -Root .
```

Use the output to report:

- project validation status;
- active task;
- task folder;
- task files state;
- whether implementation/handoff/review appear complete;
- next safe action.

## Project Validation

When practical, run:

```powershell
./.agents/scripts/validate_project.ps1 -Root .
```

Use failures as blockers and warnings as context to inspect.

## Reconstruct State

Read when present:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
```

Then identify:

- active task;
- latest completed task;
- blocked tasks;
- last handoff;
- pending review;
- next recommended action.

## Task Context

For the active task, read:

```txt
docs/tasks/TASK-XXX-name/scope.md
docs/tasks/TASK-XXX-name/implementation_plan.md
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/review.md
docs/tasks/TASK-XXX-name/decisions.md
```

## Decision

Return one next action:

- continue implementation;
- prepare missing task docs;
- review completed delivery;
- resolve inconsistency;
- ask for clarification.

If project state cannot be reconstructed safely, stop and list the missing files or contradictions.
