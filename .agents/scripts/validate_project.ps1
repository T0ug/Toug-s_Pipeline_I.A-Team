param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root
$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Test-RequiredFile {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    $failures.Add("Missing required project file: $RelativePath")
    return
  }

  $content = Get-Content -Raw -LiteralPath $path
  if ([string]::IsNullOrWhiteSpace($content)) {
    $failures.Add("Project file is empty: $RelativePath")
  }
}

function Test-RequiredDir {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Container)) {
    $failures.Add("Missing required directory: $RelativePath")
  }
}

function Test-ForbiddenPath {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (Test-Path -LiteralPath $path) {
    $failures.Add("Forbidden legacy project path exists: $RelativePath")
  }
}

Test-RequiredDir "docs/project"
Test-RequiredDir "docs/tasks"
Test-RequiredDir "docs/releases"
Test-RequiredDir "docs/archive"

Test-RequiredFile "AGENTS.md"
Test-RequiredFile ".agents/skills/execute-task/SKILL.md"
Test-RequiredFile ".agents/skills/review-delivery/SKILL.md"
Test-RequiredFile ".agents/skills/resume-session/SKILL.md"
Test-RequiredFile ".agents/skills/onboard-existing-project/SKILL.md"
Test-RequiredFile ".agents/skills/structure-project/SKILL.md"
Test-RequiredFile ".agents/scripts/init_project.ps1"
Test-RequiredFile ".agents/scripts/init_task.ps1"
Test-RequiredFile ".agents/scripts/validate_project.ps1"
Test-RequiredFile ".agents/scripts/validate_task.ps1"

Test-RequiredFile "docs/project/project_status.md"
Test-RequiredFile "docs/project/backlog.md"
Test-RequiredFile "docs/project/architecture.md"
Test-RequiredFile "docs/project/decision_log.md"

Test-ForbiddenPath "docs/tasks.md"
Test-ForbiddenPath "docs/project_status.md"
Test-ForbiddenPath "docs/handoff.md"
Test-ForbiddenPath "docs/review_report.md"
Test-ForbiddenPath "docs/architecture.md"
Test-ForbiddenPath "docs/decision_log.md"
Test-ForbiddenPath ".agents/agents"
Test-ForbiddenPath ".agents/core"
Test-ForbiddenPath ".agents/registry"
Test-ForbiddenPath ".agents/rules"
Test-ForbiddenPath ".agents/workflows"

$backlogPath = Join-Path $rootPath "docs/project/backlog.md"
if (Test-Path -LiteralPath $backlogPath -PathType Leaf) {
  $backlog = Get-Content -Raw -LiteralPath $backlogPath
  if ($backlog -notmatch 'TASK-\d{3,}') {
    $warnings.Add("Backlog has no TASK-XXX entries yet.")
  }
}

$taskRoot = Join-Path $rootPath "docs/tasks"
if (Test-Path -LiteralPath $taskRoot -PathType Container) {
  $badTaskFolders = Get-ChildItem -LiteralPath $taskRoot -Directory |
    Where-Object { $_.Name -notmatch '^TASK-\d{3,}-[a-z0-9][a-z0-9-]*$' }
  foreach ($folder in $badTaskFolders) {
    $warnings.Add("Task folder does not match TASK-XXX-name convention: docs/tasks/$($folder.Name)")
  }
}

if ($warnings.Count -gt 0) {
  Write-Host "WARNINGS"
  foreach ($warning in $warnings) {
    Write-Host "- $warning"
  }
}

if ($failures.Count -gt 0) {
  Write-Host "FAILURES"
  foreach ($failure in $failures) {
    Write-Host "- $failure"
  }
  exit 1
}

Write-Host "Project validation passed."
