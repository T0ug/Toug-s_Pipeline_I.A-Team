---
name: pipeline-router
description: Use for any Codex pipeline request, including project status, "qual o estado atual da pipeline?", continuing work, starting a task, creating a task, implementing, reviewing, validating, onboarding an existing project, or deciding the next safe action. Automatically route to the correct pipeline skill and deterministic scripts so the user does not need to name skills or commands.
---

# Pipeline Router

Use this skill as the default entrypoint for the pipeline.

The user should not need to know skill names, scripts, task paths, or workflow order.

## First Move

For almost every request, start by reconstructing state:

```powershell
./.agents/scripts/pipeline.ps1 status -Root .
```

Use the result to decide the next action.

## Route Requests

Route natural-language requests like this:

| User intent | Route |
| --- | --- |
| "qual o estado atual da pipeline?", "onde paramos?", "qual task esta ativa?" | Use `resume-session`; run `pipeline.ps1 status`. |
| "prepare este projeto", "iniciar pipeline", new repo setup | Use `structure-project`; run `pipeline.ps1 init-project`. |
| Existing codebase, missing docs, docs in subfolders, non-standard docs, or advanced project without pipeline memory | Use `onboard-existing-project`; run `pipeline.ps1 onboard` before creating tasks. |
| Team work, multiple developers, dividir tarefas, parallel work, Git branches, PR planning | Use `team-planning`; run `pipeline.ps1 plan-team`. |
| "crie uma task", "comece X", clear new work | Run `pipeline.ps1 start -Name "..."`; then use `execute-task` if implementation was requested. |
| "implemente", "corrija", "faça", code change | Run `pipeline.ps1 before-work`; then use `execute-task`. |
| "revisa", "valide", "pode aprovar?" | Run `pipeline.ps1 review`; then use `review-delivery`. |
| Finished implementation | Run `pipeline.ps1 after-work`; ensure handoff is updated. |
| Finished review | Run `pipeline.ps1 complete`; ensure project status/backlog are coherent. |

## Task Creation

If the user asks for new clear work and no matching active task exists, create a task automatically:

```powershell
./.agents/scripts/pipeline.ps1 start -Root . -Name "short task name"
```

Use a concise task name based on the user's request.

Do not create a task automatically when the request is ambiguous, risky, architectural, or asks for discussion only.

If the repository already has code but no canonical pipeline docs, do not create implementation tasks first. Route to `onboard-existing-project` and reconstruct project state from the repository.

If the user mentions team work, multiple developers, branch division, or parallel work, do not focus on only one next task. Route to `team-planning` and update `docs/project/team_plan.md`.

## Implementation

Before code changes:

```powershell
./.agents/scripts/pipeline.ps1 before-work -Root .
```

If this fails, treat the failure as a blocker unless the user explicitly overrides.

Then follow `execute-task`.

After code changes and handoff:

```powershell
./.agents/scripts/pipeline.ps1 after-work -Root .
```

## Review

Before reviewing:

```powershell
./.agents/scripts/pipeline.ps1 review -Root .
```

Then follow `review-delivery`.

After writing review:

```powershell
./.agents/scripts/pipeline.ps1 complete -Root .
```

## Output To User

Keep responses short and operational:

- current state;
- active task;
- blocker, if any;
- action taken;
- next safe action.

Do not expose long script output unless the user asks.
