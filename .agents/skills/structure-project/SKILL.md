---
name: structure-project
description: Use when Codex must initialize the docs structure for a new repository that will use this Codex task pipeline, including docs/project, docs/tasks, docs/releases, and template task files.
---

# Structure Project

Use this workflow to initialize a new repository for the pipeline.

## Preferred Script

When available, initialize the structure with:

```powershell
./.agents/scripts/init_project.ps1 -Root .
```

Then inspect the created files and fill only the project-specific facts the user provided.

## Create Folders

Create:

```txt
docs/project/
docs/tasks/
docs/releases/
docs/archive/
```

## Create Project Files

Create minimal versions of:

```txt
docs/project/vision.md
docs/project/scope.md
docs/project/architecture.md
docs/project/database.md
docs/project/api.md
docs/project/security.md
docs/project/project_status.md
docs/project/decision_log.md
docs/project/backlog.md
```

Use matching files in `.agents/templates/` as shape references when available.

Use clear placeholders only where the answer is genuinely unknown.

## Create First Task

When the user gives the first concrete task, create:

```txt
docs/tasks/TASK-001-name/
  scope.md
  implementation_plan.md
  decisions.md
  handoff.md
  review.md
```

Use `.agents/templates/task_folder.template.md` as the shape reference when available.

## Completion

Report:

- files created;
- unknowns that still need user input;
- first executable task, if any.
