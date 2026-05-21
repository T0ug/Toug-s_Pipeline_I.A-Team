param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root

function Read-FileOrEmpty {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    return Get-Content -Raw -LiteralPath $path
  }
  return ""
}

function Get-FirstRegex {
  param(
    [string]$Text,
    [string]$Pattern
  )

  $match = [regex]::Match($Text, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
  if ($match.Success) {
    return $match.Groups[1].Value.Trim()
  }
  return ""
}

function Get-TaskFolder {
  param([string]$TaskIdOrName)

  if ([string]::IsNullOrWhiteSpace($TaskIdOrName)) {
    return $null
  }

  $taskRoot = Join-Path $rootPath "docs/tasks"
  if (-not (Test-Path -LiteralPath $taskRoot -PathType Container)) {
    return $null
  }

  $direct = Join-Path $taskRoot $TaskIdOrName
  if (Test-Path -LiteralPath $direct -PathType Container) {
    return Get-Item -LiteralPath $direct
  }

  $taskId = Get-FirstRegex $TaskIdOrName '(TASK-\d{3,})'
  if ([string]::IsNullOrWhiteSpace($taskId)) {
    $taskId = $TaskIdOrName
  }

  $matches = Get-ChildItem -LiteralPath $taskRoot -Directory |
    Where-Object { $_.Name -eq $taskId -or $_.Name.StartsWith("$taskId-") }

  if ($matches.Count -ge 1) {
    return $matches[0]
  }

  return $null
}

function Get-TaskStatusFromBacklog {
  param(
    [string]$Backlog,
    [string]$TaskId
  )

  if ([string]::IsNullOrWhiteSpace($TaskId)) {
    return ""
  }

  $line = ($Backlog -split "`r?`n") | Where-Object { $_ -match [regex]::Escape($TaskId) } | Select-Object -First 1
  if ($line -and $line -match '\|\s*' + [regex]::Escape($TaskId) + '\s*\|[^|]*\|\s*([^|]+)\|') {
    return $Matches[1].Trim()
  }
  return ""
}

function Test-TaskFileState {
  param(
    [string]$TaskPath,
    [string]$FileName
  )

  $path = Join-Path $TaskPath $FileName
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    return "missing"
  }

  $content = Get-Content -Raw -LiteralPath $path
  if ([string]::IsNullOrWhiteSpace($content)) {
    return "empty"
  }

  if ($content -match 'TODO') {
    return "has_todo"
  }

  return "present"
}

$projectStatus = Read-FileOrEmpty "docs/project/project_status.md"
$backlog = Read-FileOrEmpty "docs/project/backlog.md"

$activeTask = Get-FirstRegex $projectStatus '(?s)## Active Task\s+(.+?)(?:\r?\n##|\z)'
if ([string]::IsNullOrWhiteSpace($activeTask) -or $activeTask -match 'None') {
  $activeTask = Get-FirstRegex $projectStatus '(?s)## Task ativa\s+```txt\s*(.+?)\s*```'
}
if ([string]::IsNullOrWhiteSpace($activeTask) -or $activeTask -match 'TASK-XXX|None') {
  $activeTask = Get-FirstRegex $backlog '(TASK-\d{3,}-?[a-z0-9-]*)'
}

$taskFolder = Get-TaskFolder $activeTask
$taskId = ""
$taskStatus = ""

Write-Host "# Pipeline Status"
Write-Host ""

$validateProjectScript = Join-Path $rootPath ".agents/scripts/validate_project.ps1"
if (Test-Path -LiteralPath $validateProjectScript -PathType Leaf) {
  $projectValidationOutput = & $validateProjectScript -Root $rootPath.Path 2>&1
  $projectValidationSuccess = $?
} else {
  $projectValidationOutput = @("missing script: .agents/scripts/validate_project.ps1")
  $projectValidationSuccess = $false
}

if ($projectValidationSuccess) {
  Write-Host "project_validation: passed"
} else {
  Write-Host "project_validation: failed"
}
foreach ($line in $projectValidationOutput) {
  if (-not [string]::IsNullOrWhiteSpace([string]$line)) {
    Write-Host "project_validation_detail: $line"
  }
}

Write-Host ""
Write-Host "project_docs:"
foreach ($file in @(
  "docs/project/project_status.md",
  "docs/project/backlog.md",
  "docs/project/architecture.md",
  "docs/project/decision_log.md"
)) {
  $path = Join-Path $rootPath $file
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Write-Host "- ${file}: present"
  } else {
    Write-Host "- ${file}: missing"
  }
}

Write-Host ""
if ($taskFolder) {
  $taskId = Get-FirstRegex $taskFolder.Name '^(TASK-\d{3,})'
  $taskStatus = Get-TaskStatusFromBacklog $backlog $taskId

  Write-Host "active_task: $($taskFolder.Name)"
  Write-Host "active_task_folder: docs/tasks/$($taskFolder.Name)"
  if (-not [string]::IsNullOrWhiteSpace($taskStatus)) {
    Write-Host "active_task_status: $taskStatus"
  }

  Write-Host ""
  Write-Host "task_files:"
  foreach ($file in @("scope.md", "implementation_plan.md", "decisions.md", "handoff.md", "review.md")) {
    Write-Host "- ${file}: $(Test-TaskFileState $taskFolder.FullName $file)"
  }

  Write-Host ""
  foreach ($stage in @("ready", "implemented", "reviewed")) {
    $validateTaskScript = Join-Path $rootPath ".agents/scripts/validate_task.ps1"
    if (Test-Path -LiteralPath $validateTaskScript -PathType Leaf) {
      $taskValidationOutput = & $validateTaskScript -Root $rootPath.Path -Task $taskId -Stage $stage 2>&1
      $taskValidationSuccess = $?
    } else {
      $taskValidationOutput = @("missing script: .agents/scripts/validate_task.ps1")
      $taskValidationSuccess = $false
    }

    if ($taskValidationSuccess) {
      Write-Host "task_validation_${stage}: passed"
    } else {
      Write-Host "task_validation_${stage}: failed"
    }
    foreach ($line in $taskValidationOutput) {
      if (-not [string]::IsNullOrWhiteSpace([string]$line)) {
        Write-Host "task_validation_${stage}_detail: $line"
      }
    }
  }

  $handoff = Read-FileOrEmpty "docs/tasks/$($taskFolder.Name)/handoff.md"
  $review = Read-FileOrEmpty "docs/tasks/$($taskFolder.Name)/review.md"

  Write-Host ""
  if ($handoff -match 'Status:\s*not_started|Not implemented yet') {
    Write-Host "next_safe_action: continue implementation or update handoff after implementation"
  } elseif ($review -match 'Outcome:\s*pending|Review has not been performed') {
    Write-Host "next_safe_action: review delivery"
  } elseif ($review -match 'Outcome:\s*(approved|approved_with_notes)') {
    Write-Host "next_safe_action: update project status or select next backlog task"
  } else {
    Write-Host "next_safe_action: inspect task docs and resolve unclear state"
  }
} else {
  Write-Host "active_task: not_found"
  Write-Host "next_safe_action: select or initialize an active task"
}

exit 0
