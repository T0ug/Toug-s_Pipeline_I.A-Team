param(
  [Parameter(Position = 0)]
  [ValidateSet("status", "init-project", "start", "before-work", "after-work", "review", "complete", "validate")]
  [string]$Action = "status",

  [string]$Root = ".",
  [string]$Task = "",
  [string]$Name = "",
  [string]$Id = "",
  [string]$Type = "chore"
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root
$scriptsPath = Join-Path $rootPath ".agents/scripts"

function Invoke-PipelineScript {
  param(
    [string]$ScriptName,
    [hashtable]$Arguments = @{}
  )

  $scriptPath = Join-Path $scriptsPath $ScriptName
  if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
    throw "Missing script: .agents/scripts/$ScriptName"
  }

  & $scriptPath @Arguments
  $success = $?
  if ($null -ne $LASTEXITCODE) {
    $success = $LASTEXITCODE -eq 0
  }

  if (-not $success) {
    throw "$ScriptName failed with exit code $LASTEXITCODE"
  }
}

function Read-Text {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    return Get-Content -Raw -LiteralPath $path
  }
  return ""
}

function Get-NextTaskId {
  $max = 0
  $texts = @(
    (Read-Text "docs/project/backlog.md")
  )

  $taskRoot = Join-Path $rootPath "docs/tasks"
  if (Test-Path -LiteralPath $taskRoot -PathType Container) {
    $texts += (Get-ChildItem -LiteralPath $taskRoot -Directory | ForEach-Object { $_.Name })
  }

  foreach ($text in $texts) {
    foreach ($match in [regex]::Matches($text, 'TASK-(\d{3,})')) {
      $value = [int]$match.Groups[1].Value
      if ($value -gt $max) {
        $max = $value
      }
    }
  }

  return "TASK-{0:D3}" -f ($max + 1)
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

function Resolve-Task {
  param([string]$TaskValue)

  if (-not [string]::IsNullOrWhiteSpace($TaskValue)) {
    return $TaskValue
  }

  $projectStatus = Read-Text "docs/project/project_status.md"
  $backlog = Read-Text "docs/project/backlog.md"

  $activeTask = Get-FirstRegex $projectStatus '(?s)## Active Task\s+(.+?)(?:\r?\n##|\z)'
  if ([string]::IsNullOrWhiteSpace($activeTask) -or $activeTask -match 'None|TASK-XXX') {
    $activeTask = Get-FirstRegex $projectStatus '(?s)## Task ativa\s+```txt\s*(.+?)\s*```'
  }
  if (-not [string]::IsNullOrWhiteSpace($activeTask) -and $activeTask -notmatch 'None|TASK-XXX') {
    $taskId = Get-FirstRegex $activeTask '(TASK-\d{3,})'
    if (-not [string]::IsNullOrWhiteSpace($taskId)) {
      return $taskId
    }
    return $activeTask
  }

  $activeLine = ($backlog -split "`r?`n") |
    Where-Object { $_ -match '\|\s*TASK-\d{3,}\s*\|' -and $_ -match '\|\s*active\s*\|' } |
    Select-Object -First 1
  if ($activeLine) {
    return Get-FirstRegex $activeLine '(TASK-\d{3,})'
  }

  $firstTask = Get-FirstRegex $backlog '(TASK-\d{3,})'
  if (-not [string]::IsNullOrWhiteSpace($firstTask)) {
    return $firstTask
  }

  throw "No task could be inferred. Create one with: pipeline.ps1 start -Name `"task name`""
}

switch ($Action) {
  "status" {
    Invoke-PipelineScript "status_pipeline.ps1" @{ Root = $rootPath.Path }
    break
  }

  "init-project" {
    Invoke-PipelineScript "init_project.ps1" @{ Root = $rootPath.Path }
    Invoke-PipelineScript "validate_project.ps1" @{ Root = $rootPath.Path }
    break
  }

  "start" {
    if ([string]::IsNullOrWhiteSpace($Name)) {
      throw "The start action requires -Name."
    }

    if ([string]::IsNullOrWhiteSpace($Id)) {
      $Id = Get-NextTaskId
    }

    $projectStatusPath = Join-Path $rootPath "docs/project/project_status.md"
    if (-not (Test-Path -LiteralPath $projectStatusPath -PathType Leaf)) {
      Invoke-PipelineScript "init_project.ps1" @{ Root = $rootPath.Path }
    }

    Invoke-PipelineScript "init_task.ps1" @{
      Root = $rootPath.Path
      Id = $Id
      Name = $Name
      Type = $Type
      Status = "pending"
    }
    Invoke-PipelineScript "validate_task.ps1" @{
      Root = $rootPath.Path
      Task = $Id
      Stage = "ready"
    }
    break
  }

  "before-work" {
    $resolvedTask = Resolve-Task $Task
    Invoke-PipelineScript "validate_project.ps1" @{ Root = $rootPath.Path }
    Invoke-PipelineScript "validate_task.ps1" @{
      Root = $rootPath.Path
      Task = $resolvedTask
      Stage = "ready"
    }
    break
  }

  "after-work" {
    $resolvedTask = Resolve-Task $Task
    Invoke-PipelineScript "validate_task.ps1" @{
      Root = $rootPath.Path
      Task = $resolvedTask
      Stage = "implemented"
    }
    break
  }

  "review" {
    $resolvedTask = Resolve-Task $Task
    Invoke-PipelineScript "validate_task.ps1" @{
      Root = $rootPath.Path
      Task = $resolvedTask
      Stage = "implemented"
    }
    break
  }

  "complete" {
    $resolvedTask = Resolve-Task $Task
    Invoke-PipelineScript "validate_task.ps1" @{
      Root = $rootPath.Path
      Task = $resolvedTask
      Stage = "complete"
    }
    break
  }

  "validate" {
    Invoke-PipelineScript "validate_pipeline.ps1" @{ Root = $rootPath.Path }
    if (Test-Path -LiteralPath (Join-Path $rootPath "docs/project") -PathType Container) {
      Invoke-PipelineScript "validate_project.ps1" @{ Root = $rootPath.Path }
    } else {
      Write-Host "Project docs not initialized; skipped validate_project.ps1."
    }
    break
  }
}
