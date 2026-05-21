---
name: team-planning
description: Use when Codex must prepare, update, or reason about team work distribution, parallel task planning, Git branches, PR boundaries, task ownership, claim/release of tasks, or a full task map for multiple developers using the Codex pipeline.
---

# Team Planning

Use this skill when the user is working with a team, not just one next task.

## Principle

For team work, the pipeline needs a map of all relevant tasks, ownership, dependencies, and safe parallelization.

Do not suggest only "start the next task" when the user needs work split across multiple people.

## Team Map

When practical, run:

```powershell
./.agents/scripts/pipeline.ps1 plan-team -Root .
```

This creates or updates:

```txt
docs/project/team_plan.md
```

Use this file to decide:

- which tasks are unclaimed;
- which tasks are active;
- which tasks can be parallelized;
- which tasks are blocked by dependencies;
- which branch/PR should exist for each task.

## Claiming Work

When a developer starts a task, claim it:

```powershell
./.agents/scripts/pipeline.ps1 claim -Root . -Task TASK-XXX -Owner "name"
```

This updates task scope, backlog notes, and team plan.

## Git Rules

- One task per branch.
- One task per PR.
- Branch name should include the task id.
- PR title should include the task id.
- Avoid multiple owners on one task unless the task has an explicit split.

## Before Creating Tasks

For an existing project, run onboarding first:

```powershell
./.agents/scripts/pipeline.ps1 onboard -Root .
```

Create tasks from actual current work, detected gaps, risks, or the user's requested roadmap.

Do not create a fake "from scratch" task sequence for an advanced codebase.
