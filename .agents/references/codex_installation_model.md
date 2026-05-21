# Codex Installation Model

Use this reference when installing the pipeline into a real project.

## Root Layout

Install these files at the repository root:

```txt
AGENTS.md
.agents/
  skills/
  templates/
  references/
  scripts/
docs/
  project/
  tasks/
  releases/
  archive/
```

## Active Codex Surface

Codex actively benefits from:

- root `AGENTS.md`;
- `.agents/skills/*/SKILL.md`;
- scripts called by skills or users;
- repository docs read during execution.

## Reference Surface

These are useful for humans and for skills to read on demand:

- `.agents/templates/`;
- `.agents/references/`;

## Do Not Rely On

Do not add `.agents/rules/` for behavioral enforcement. Use root `AGENTS.md` or a skill.

Do not add `.agents/agents/` or `.agents/workflows/` for roleplay or parallel workflow definitions. Use skills and explicit workflow instructions instead.

Do not keep legacy aliases for old skill names. Skills should be the real Codex workflow surface.

## Recommended Usage

Common prompts:

```txt
Use execute-task for TASK-014-google-login.
```

```txt
Use review-delivery for TASK-014-google-login.
```

```txt
Use resume-session and tell me the next safe action.
```

```txt
Use onboard-existing-project to align this repo with the pipeline.
```

## Deterministic Scripts

Prefer scripts when creating or validating pipeline artifacts:

```powershell
./.agents/scripts/pipeline.ps1 status -Root .
./.agents/scripts/pipeline.ps1 onboard -Root .
./.agents/scripts/pipeline.ps1 plan-team -Root .
./.agents/scripts/pipeline.ps1 claim -Root . -Task TASK-001 -Owner "name"
./.agents/scripts/init_project.ps1 -Root .
./.agents/scripts/init_task.ps1 -Root . -Id TASK-001 -Name "first task"
./.agents/scripts/validate_project.ps1 -Root .
./.agents/scripts/validate_task.ps1 -Root . -Task TASK-001 -Stage ready
./.agents/scripts/status_pipeline.ps1 -Root .
```

Use `validate_task.ps1` stages:

```txt
ready
implemented
reviewed
complete
```

## Validation

Run:

```powershell
./.agents/scripts/validate_pipeline.ps1 -Root .
```

For this template repository, run it from the parent directory with:

```powershell
./pipeline/.agents/scripts/validate_pipeline.ps1 -Root ./pipeline
```
