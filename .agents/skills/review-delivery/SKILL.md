---
name: review-delivery
description: Use when Codex must review, validate, or audit a completed task delivery against the repository pipeline, task scope, implementation plan, handoff evidence, architecture, tests, and documentation.
---

# Review Delivery

Use this workflow for task review.

## Required Reading

Read when present:

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
docs/tasks/TASK-XXX-name/scope.md
docs/tasks/TASK-XXX-name/implementation_plan.md
docs/tasks/TASK-XXX-name/handoff.md
docs/tasks/TASK-XXX-name/decisions.md
```

Inspect the code changes and validation evidence before deciding.

When practical, run:

```powershell
./.agents/scripts/validate_task.ps1 -Root . -Task TASK-XXX -Stage implemented
```

## Review Checklist

Validate:

- implementation matches task scope;
- acceptance criteria are satisfied;
- architecture and project decisions are respected;
- no unrelated task was mixed in;
- security, database, API, or deployment impact is documented;
- validation evidence is reproducible;
- handoff is complete enough for another developer or agent.

## Outcomes

Use exactly one:

```txt
approved
approved_with_notes
rejected
```

Reject when evidence is missing, scope was not met, architecture is contradicted, or validation cannot be trusted.

## Review Document

Update:

```txt
docs/tasks/TASK-XXX-name/review.md
```

Use `.agents/templates/review.template.md` as the shape reference if available.

Include:

- outcome;
- evidence reviewed;
- findings ordered by severity;
- required fixes when rejected;
- risks that remain;
- recommendation for next step.

Do not implement fixes while acting as reviewer unless the user explicitly asks to switch from review to implementation.

After writing the review, validate reviewed state when practical:

```powershell
./.agents/scripts/validate_task.ps1 -Root . -Task TASK-XXX -Stage reviewed
```
