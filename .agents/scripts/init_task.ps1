param(
  [Parameter(Mandatory = $true)]
  [string]$Id,

  [Parameter(Mandatory = $true)]
  [string]$Name,

  [string]$Root = ".",
  [string]$Type = "chore",
  [string]$Status = "pending"
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root

if ($Id -notmatch '^TASK-\d{3,}$') {
  throw "Task Id must match TASK-XXX, for example TASK-014."
}

function ConvertTo-Slug {
  param([string]$Value)

  $slug = $Value.ToLowerInvariant()
  $slug = $slug -replace '[^a-z0-9]+', '-'
  $slug = $slug.Trim('-')
  if ([string]::IsNullOrWhiteSpace($slug)) {
    throw "Task name must contain at least one letter or number."
  }
  return $slug
}

function Ensure-Dir {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Ensure-File {
  param(
    [string]$Path,
    [string]$Content
  )
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
    Write-Host "created $($Path.Substring($rootPath.Path.Length + 1))"
  } else {
    Write-Host "exists  $($Path.Substring($rootPath.Path.Length + 1))"
  }
}

$slug = ConvertTo-Slug $Name
$taskFolderName = "$Id-$slug"
$taskRel = "docs/tasks/$taskFolderName"
$taskPath = Join-Path $rootPath $taskRel

Ensure-Dir (Join-Path $rootPath "docs")
Ensure-Dir (Join-Path $rootPath "docs/tasks")
Ensure-Dir (Join-Path $rootPath "docs/project")
Ensure-Dir $taskPath

$created = (Get-Date).ToString("yyyy-MM-dd")

Ensure-File (Join-Path $taskPath "scope.md") @"
# $Id - $Name

## Identification

- ID: $Id
- Name: $Name
- Type: $Type
- Status: $Status
- Created: $created
- Updated: $created

## Objective

TODO: describe the verifiable outcome.

## Context

TODO: explain why this task exists and how it relates to the project.

## Scope

- TODO

## Out Of Scope

- TODO

## Acceptance Criteria

- [ ] TODO

## Required Inputs

- TODO

## Dependencies

- None recorded.

## Constraints

- TODO

## Expected Impact

- TODO

## Expected Evidence

- TODO: list validation commands, manual checks, logs, screenshots, or expected outputs.
"@

Ensure-File (Join-Path $taskPath "implementation_plan.md") @"
# Implementation Plan - $Id

## Technical Objective

TODO: describe the implementation approach.

## Required Reading

```txt
docs/project/project_status.md
docs/project/backlog.md
docs/project/architecture.md
docs/project/decision_log.md
$taskRel/scope.md
```

## Strategy

- TODO

## Proposed Steps

- [ ] TODO

## Likely Affected Files

```txt
TODO
```

## Protected Areas

```txt
TODO
```

## Technical Risks

- TODO

## Validation Plan

- TODO: command or manual check.

## Completion Criteria

- [ ] Scope was implemented.
- [ ] Acceptance criteria were met.
- [ ] Relevant validation was run or skipped with a documented reason.
- [ ] Handoff was updated.
- [ ] Local decisions were documented when needed.
"@

Ensure-File (Join-Path $taskPath "decisions.md") @"
# Decisions - $Id

Task-local decisions belong here.

Promote decisions to `docs/project/decision_log.md` only when they affect architecture, security, database design, API contracts, deployment, project-wide standards, multiple systems, or long-term maintenance.

## Local Decisions

No local decisions recorded yet.
"@

Ensure-File (Join-Path $taskPath "handoff.md") @"
# Handoff - $Id

Status: not_started

## Summary

Not implemented yet.

## Files Changed

- None yet.

## Validation

- Not run yet.

## Risks And Pending Issues

- None recorded yet.

## Next Step

Implement the task or update this handoff after implementation.
"@

Ensure-File (Join-Path $taskPath "review.md") @"
# Review - $Id

Status: pending

Outcome: pending

## Evidence Reviewed

- None yet.

## Findings

- Review has not been performed.

## Recommendation

Run review after implementation and handoff are complete.
"@

$backlogPath = Join-Path $rootPath "docs/project/backlog.md"
if (-not (Test-Path -LiteralPath $backlogPath -PathType Leaf)) {
  Set-Content -LiteralPath $backlogPath -Value @"
# Backlog

## Tasks

| ID | Name | Status | Folder | Notes |
| --- | --- | --- | --- | --- |
"@ -Encoding UTF8
}

$backlog = Get-Content -Raw -LiteralPath $backlogPath
if ($backlog -notmatch [regex]::Escape($Id)) {
  Add-Content -LiteralPath $backlogPath -Value "| $Id | $Name | $Status | ``$taskRel`` | Created by init_task.ps1. |"
  Write-Host "updated docs/project/backlog.md"
} else {
  Write-Host "backlog already references $Id"
}

Write-Host "Task initialized: $taskRel"
