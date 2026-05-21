param(
  [Parameter(Mandatory = $true)]
  [string]$Task,

  [string]$Root = ".",

  [ValidateSet("ready", "implemented", "reviewed", "complete")]
  [string]$Stage = "ready"
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root
$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Resolve-TaskFolder {
  param([string]$TaskValue)

  $taskRoot = Join-Path $rootPath "docs/tasks"
  if (-not (Test-Path -LiteralPath $taskRoot -PathType Container)) {
    $failures.Add("Missing docs/tasks directory.")
    return $null
  }

  $direct = Join-Path $taskRoot $TaskValue
  if (Test-Path -LiteralPath $direct -PathType Container) {
    return (Resolve-Path -LiteralPath $direct).Path
  }

  $matches = Get-ChildItem -LiteralPath $taskRoot -Directory |
    Where-Object { $_.Name -eq $TaskValue -or $_.Name.StartsWith("$TaskValue-") }

  if ($matches.Count -eq 1) {
    return $matches[0].FullName
  }

  if ($matches.Count -gt 1) {
    $failures.Add("Multiple task folders match '$TaskValue'. Pass the full folder name.")
    return $null
  }

  $failures.Add("Task folder not found for '$TaskValue'.")
  return $null
}

function Test-RequiredFile {
  param(
    [string]$Folder,
    [string]$Name
  )

  $path = Join-Path $Folder $Name
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    $failures.Add("Missing task file: $Name")
    return $null
  }

  $content = Get-Content -Raw -LiteralPath $path
  if ([string]::IsNullOrWhiteSpace($content)) {
    $failures.Add("Task file is empty: $Name")
  }
  return $content
}

function Test-NotPlaceholder {
  param(
    [string]$Content,
    [string]$Name
  )

  if ($null -eq $Content) {
    return
  }

  if ($Content -match 'TODO') {
    $warnings.Add("$Name still contains TODO markers.")
  }
}

$taskFolder = Resolve-TaskFolder $Task
if ($null -ne $taskFolder) {
  $folderName = Split-Path -Leaf $taskFolder
  if ($folderName -notmatch '^TASK-\d{3,}-[a-z0-9][a-z0-9-]*$') {
    $warnings.Add("Task folder name does not match TASK-XXX-name convention: $folderName")
  }

  $scope = Test-RequiredFile $taskFolder "scope.md"
  $plan = Test-RequiredFile $taskFolder "implementation_plan.md"
  $decisions = Test-RequiredFile $taskFolder "decisions.md"
  $handoff = Test-RequiredFile $taskFolder "handoff.md"
  $review = Test-RequiredFile $taskFolder "review.md"

  Test-NotPlaceholder $scope "scope.md"
  Test-NotPlaceholder $plan "implementation_plan.md"

  if ($Stage -in @("implemented", "reviewed", "complete")) {
    if ($handoff -match 'Status:\s*not_started') {
      $failures.Add("handoff.md is still not_started.")
    }
    if ($handoff -match 'Not implemented yet') {
      $failures.Add("handoff.md still says the task is not implemented.")
    }
    if ($handoff -notmatch 'Validation') {
      $failures.Add("handoff.md must include validation evidence or a skipped-validation reason.")
    }
  }

  if ($Stage -in @("reviewed", "complete")) {
    if ($review -match 'Outcome:\s*pending') {
      $failures.Add("review.md outcome is still pending.")
    }
    if ($review -match 'Review has not been performed') {
      $failures.Add("review.md still says review has not been performed.")
    }
  }

  if ($Stage -eq "complete") {
    if ($review -notmatch 'Outcome:\s*(approved|approved_with_notes)') {
      $failures.Add("complete stage requires review.md outcome approved or approved_with_notes.")
    }
  }
}

$backlogPath = Join-Path $rootPath "docs/project/backlog.md"
if (Test-Path -LiteralPath $backlogPath -PathType Leaf) {
  $backlog = Get-Content -Raw -LiteralPath $backlogPath
  $taskId = if ($Task -match '^(TASK-\d{3,})') { $Matches[1] } else { $Task }
  if ($backlog -notmatch [regex]::Escape($taskId)) {
    $warnings.Add("docs/project/backlog.md does not reference $taskId.")
  }
} else {
  $warnings.Add("docs/project/backlog.md is missing; project validation will fail.")
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

Write-Host "Task validation passed for $Task at stage $Stage."
