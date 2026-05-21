---
name: onboard-existing-project
description: Use when Codex must adapt an existing, advanced, partially documented, undocumented, or non-standard codebase to this Codex pipeline. Before creating tasks, inspect the entire repository, find docs even in subfolders or non-canonical locations, reconstruct what the project already is, and create factual docs/project memory.
---

# Onboard Existing Project

Use this workflow before normal execution in any project that did not start inside this pipeline.

Onboarding is repository research first, task planning second.

Do not treat an existing codebase as a new project.

## Non-Negotiable Rule

Before creating backlog tasks, inspect the existing repository and reconstruct:

- what the project already does;
- how it is structured;
- which docs already exist, even outside `docs/project/`;
- what appears complete;
- what appears incomplete or active;
- what risks or unknowns remain.

Never propose "starting from the beginning" just because canonical pipeline docs are missing.

## Scan First

When practical, run:

```powershell
./.agents/scripts/pipeline.ps1 onboard -Root .
```

This runs repository scan, initializes canonical docs if needed, rescans, and validates project structure.

If you need only the research scan:

```powershell
./.agents/scripts/pipeline.ps1 scan -Root .
```

The scan creates:

```txt
docs/project/onboarding_research.md
docs/project/code_map.md
```

Read these generated files before writing or changing project docs.

## Inspect Existing Evidence

Search the whole repository, not only root docs.

Inspect:

- README and markdown docs in any folder;
- docs outside the expected pipeline structure;
- package manifests and lockfiles;
- framework config;
- source directories;
- routes, controllers, services, workers, jobs, commands;
- database schemas and migrations;
- tests and test config;
- CI/deploy/container files;
- environment examples;
- TODO/FIXME notes;
- existing issue/task/changelog/release notes if present.

Ignore generated/vendor/build folders unless they are the only evidence available.

## Migrate Meaning, Not Files Blindly

If docs already exist outside the canonical structure:

- read and summarize them;
- preserve their meaning in `docs/project/`;
- mention source paths in `docs/project/onboarding_research.md`;
- do not delete or move original docs unless the user asks.

## Create Or Update Project Memory

Create or update:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
docs/project/onboarding_research.md
docs/project/code_map.md
```

Optional project files should be filled when evidence exists:

```txt
docs/project/vision.md
docs/project/scope.md
docs/project/database.md
docs/project/api.md
docs/project/security.md
```

Keep documents factual. Mark unknowns explicitly instead of inventing.

## Backlog And Tasks

For advanced existing projects, do not create tasks from "project beginning".

Create backlog entries only for:

- active or incomplete work detected in code/docs;
- user-requested work;
- migration gaps needed to finish onboarding;
- risks or inconsistencies that block safe continuation.

Create a `docs/tasks/TASK-XXX-name/` folder only when there is a concrete executable task.

If no active work is clear, do not invent tasks. Ask which existing area should be worked on next and provide a project state summary.

## Completion

End onboarding with:

- project type and current state;
- existing docs found and how they map to canonical docs;
- main modules and architecture summary;
- detected tests/build/validation commands;
- active or incomplete work, if any;
- risks and unknowns;
- next safe action.

Do not implement feature work during onboarding unless the user explicitly asks after project memory is created.
