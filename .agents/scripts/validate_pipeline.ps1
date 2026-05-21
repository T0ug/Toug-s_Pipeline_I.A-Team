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
    $failures.Add("Missing required file: $RelativePath")
  }
}

function Test-NoPattern {
  param(
    [string]$Pattern,
    [string]$Message
  )

  $matches = Get-ChildItem -LiteralPath $rootPath -Recurse -File -Include *.md,*.ps1 |
    Select-String -Pattern $Pattern -SimpleMatch

  foreach ($match in $matches) {
    if ($PSCommandPath -and ((Resolve-Path -LiteralPath $match.Path).Path -eq (Resolve-Path -LiteralPath $PSCommandPath).Path)) {
      continue
    }
    $relative = Resolve-Path -LiteralPath $match.Path -Relative
    $failures.Add("$Message at ${relative}:$($match.LineNumber)")
  }
}

function Test-ActiveFileNoLegacyPath {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    return
  }

  $legacyPatterns = @(
    "docs/tasks.md",
    "docs/project_status.md",
    "docs/handoff.md",
    "docs/review_report.md",
    "GEMINI.md"
  )

  foreach ($pattern in $legacyPatterns) {
    $matches = Select-String -LiteralPath $path -Pattern $pattern -SimpleMatch
    foreach ($match in $matches) {
      $warnings.Add("Legacy path or non-Codex reference in active file ${RelativePath}:$($match.LineNumber): $pattern")
    }
  }
}

function Test-ForbiddenPathAbsent {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (Test-Path -LiteralPath $path) {
    $failures.Add("Forbidden non-native path exists: $RelativePath")
  }
}

Test-RequiredFile "AGENTS.md"
Test-RequiredFile ".agents/skills/execute-task/SKILL.md"
Test-RequiredFile ".agents/skills/review-delivery/SKILL.md"
Test-RequiredFile ".agents/skills/resume-session/SKILL.md"
Test-RequiredFile ".agents/skills/onboard-existing-project/SKILL.md"
Test-RequiredFile ".agents/skills/structure-project/SKILL.md"
Test-RequiredFile ".agents/skills/pipeline-router/SKILL.md"
Test-RequiredFile ".agents/skills/team-planning/SKILL.md"
Test-RequiredFile ".agents/scripts/pipeline.ps1"
Test-RequiredFile ".agents/scripts/scan_project.ps1"
Test-RequiredFile ".agents/scripts/plan_team.ps1"
Test-RequiredFile ".agents/scripts/claim_task.ps1"
Test-RequiredFile ".agents/scripts/init_project.ps1"
Test-RequiredFile ".agents/scripts/init_task.ps1"
Test-RequiredFile ".agents/scripts/validate_project.ps1"
Test-RequiredFile ".agents/scripts/validate_task.ps1"
Test-RequiredFile ".agents/scripts/status_pipeline.ps1"

Test-ForbiddenPathAbsent ".agents/agents"
Test-ForbiddenPathAbsent ".agents/core"
Test-ForbiddenPathAbsent ".agents/registry"
Test-ForbiddenPathAbsent ".agents/rules"
Test-ForbiddenPathAbsent ".agents/workflows"
Test-ForbiddenPathAbsent ".agents/skills/clarify_intent"
Test-ForbiddenPathAbsent ".agents/skills/design_architecture"
Test-ForbiddenPathAbsent ".agents/skills/implement_task"
Test-ForbiddenPathAbsent ".agents/skills/orchestrate_project"
Test-ForbiddenPathAbsent ".agents/skills/research_existing_project"
Test-ForbiddenPathAbsent ".agents/skills/validate_delivery"

Test-NoPattern "<<<<<<<" "Unresolved merge marker"
Test-NoPattern ">>>>>>>" "Unresolved merge marker"
Test-NoPattern "trigger: always_on" "Legacy always-on trigger"

Test-ActiveFileNoLegacyPath "AGENTS.md"
Test-ActiveFileNoLegacyPath ".agents/skills/execute-task/SKILL.md"
Test-ActiveFileNoLegacyPath ".agents/skills/review-delivery/SKILL.md"
Test-ActiveFileNoLegacyPath ".agents/skills/resume-session/SKILL.md"
Test-ActiveFileNoLegacyPath ".agents/skills/onboard-existing-project/SKILL.md"
Test-ActiveFileNoLegacyPath ".agents/skills/structure-project/SKILL.md"
Test-ActiveFileNoLegacyPath ".agents/skills/pipeline-router/SKILL.md"
Test-ActiveFileNoLegacyPath ".agents/skills/team-planning/SKILL.md"

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

Write-Host "Pipeline validation passed."
