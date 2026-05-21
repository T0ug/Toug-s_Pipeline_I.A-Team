---
name: onboard-existing-project
description: Use when Codex must adapt an existing codebase or partially documented project to this Codex pipeline by inspecting current structure, reconstructing intent, and creating minimal docs/project and docs/tasks artifacts.
---

# Onboard Existing Project

Use this workflow before normal execution in a project that did not start with this pipeline.

## Initialize Docs

When the project does not have the canonical docs structure, prefer:

```powershell
./.agents/scripts/init_project.ps1 -Root .
```

Then replace placeholders with facts discovered from the repository.

## Inspect

Read the repository structure, package files, README, existing docs, tests, config, and primary source directories.

Identify:

- application type;
- main modules;
- framework and runtime;
- database and API boundaries;
- security or deployment clues;
- current incomplete or active work.

## Create Minimal Project Memory

Create or update:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
```

Use matching files in `.agents/templates/` as shape references when available.

Keep these documents factual. Mark unknowns explicitly instead of inventing.

## Create Initial Tasks

If active work is known, create:

```txt
docs/tasks/TASK-XXX-name/
  scope.md
  implementation_plan.md
  decisions.md
  handoff.md
  review.md
```

If active work is unknown, create backlog entries only and ask which task should be executed first.

## Completion

End onboarding with:

- current state summary;
- known gaps;
- next recommended task;
- docs created or changed.

Do not implement feature work during onboarding unless the user explicitly asks after the docs are in place.

Run project validation when practical:

```powershell
./.agents/scripts/validate_project.ps1 -Root .
```
