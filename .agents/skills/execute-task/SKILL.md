---
name: execute-task
description: Use when Codex must implement a defined task, feature, bugfix, refactor, migration, or code change in a repository that uses the task-scoped docs pipeline with docs/project and docs/tasks/TASK-XXX folders.
---

# Execute Task

Use this workflow to implement one task at a time.

## Required Context

Read these project files when they exist:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
```

If the task touches database, API, security, deployment, or product scope, also read the relevant files in `docs/project/`.

## Task Setup

1. Identify the active task from the user request, backlog, project status, or branch name.
2. Use a stable task identity: `TASK-XXX-name`.
3. Locate or create:

```txt
docs/tasks/TASK-XXX-name/
```

4. Ensure these files exist before implementation:

```txt
scope.md
implementation_plan.md
decisions.md
handoff.md
review.md
```

If `scope.md` or `implementation_plan.md` is missing and the request is clear, create the minimal version needed. If the request is ambiguous or risky, stop and ask.

When creating a new task folder, prefer:

```powershell
./.agents/scripts/init_task.ps1 -Root . -Id TASK-XXX -Name "task name"
```

If the script is unavailable, use `.agents/templates/task_folder.template.md` as the shape reference.

Before implementation, validate task readiness when practical:

```powershell
./.agents/scripts/validate_task.ps1 -Root . -Task TASK-XXX -Stage ready
```

## Implementation

1. Extract objective, scope limits, non-goals, acceptance criteria, risks, and expected validation.
2. Inspect the existing code before editing.
3. Make the smallest change that satisfies the task.
4. Follow existing project architecture and local style.
5. Do not perform unrelated cleanup or opportunistic refactors.
6. Record task-local tradeoffs in `decisions.md`.

If the task requires an architectural or security decision, stop and surface it unless the user already approved it.

## Validation

Run the most relevant validation available for the changed area.

If validation cannot be run, record:

- command that should be run;
- reason it was not run;
- residual risk.

## Handoff

Update:

```txt
docs/tasks/TASK-XXX-name/handoff.md
```

Use `.agents/templates/handoff.template.md` as the shape reference if available.

Include:

- task identity and objective;
- scope implemented;
- files changed;
- behavior changed;
- validation commands and results;
- decisions made;
- risks and pending issues;
- recommended next step.

## Completion

After implementation and handoff, validate the task state when practical:

```powershell
./.agents/scripts/validate_task.ps1 -Root . -Task TASK-XXX -Stage implemented
```

Do not mark work complete unless implementation and handoff are both done.
