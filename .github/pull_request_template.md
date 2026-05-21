# Pipeline Checklist

## Task

- Task:
- Folder: `docs/tasks/TASK-XXX-name/`

## Required Checks

- [ ] `./.agents/scripts/pipeline.ps1 status -Root .` was checked.
- [ ] `./.agents/scripts/pipeline.ps1 plan-team -Root .` was checked when this affects team work.
- [ ] `./.agents/scripts/validate_pipeline.ps1 -Root .` passes.
- [ ] `./.agents/scripts/validate_project.ps1 -Root .` passes when project docs are initialized.
- [ ] `./.agents/scripts/validate_task.ps1 -Root . -Task TASK-XXX -Stage implemented` passes for implementation PRs.
- [ ] `handoff.md` was updated with changed files, validation, risks, and next step.
- [ ] `review.md` was updated when this PR includes review work.

## Scope

- [ ] This PR contains one task only.
- [ ] The task is claimed in `docs/project/team_plan.md` or the PR explains why not.
- [ ] No unrelated refactor or cleanup was mixed in.
- [ ] Global docs under `docs/project/` were changed only when the decision affects the whole project.

## Notes

Add validation evidence, skipped-validation reasons, risks, or follow-up tasks here.
