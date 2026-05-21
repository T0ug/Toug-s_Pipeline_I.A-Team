param(
  [Parameter(Mandatory = $true)]
  [string]$Task,

  [Parameter(Mandatory = $true)]
  [string]$Owner,

  [string]$Root = ".",
  [string]$Status = "active",
  [string]$Branch = ""
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root
$tasksRoot = Join-Path $rootPath "docs/tasks"

function Resolve-TaskFolder {
  param([string]$TaskValue)
  if (-not (Test-Path -LiteralPath $tasksRoot -PathType Container)) {
    throw "Missing docs/tasks."
  }
  $direct = Join-Path $tasksRoot $TaskValue
  if (Test-Path -LiteralPath $direct -PathType Container) {
    return Get-Item -LiteralPath $direct
  }
  $matches = @(Get-ChildItem -LiteralPath $tasksRoot -Directory | Where-Object { $_.Name -eq $TaskValue -or $_.Name.StartsWith("$TaskValue-") })
  if ($matches.Count -eq 1) { return $matches[0] }
  if ($matches.Count -gt 1) { throw "Multiple tasks match $TaskValue. Use full folder name." }
  throw "Task not found: $TaskValue"
}

function Set-OrAppendLine {
  param(
    [string]$Path,
    [string]$Pattern,
    [string]$Line
  )
  $lines = @(Get-Content -LiteralPath $Path)
  $updated = $false
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match $Pattern) {
      $lines[$i] = $Line
      $updated = $true
      break
    }
  }
  if (-not $updated) {
    $lines += $Line
  }
  Set-Content -LiteralPath $Path -Value $lines -Encoding UTF8
}

$folder = Resolve-TaskFolder $Task
$taskId = if ($folder.Name -match '^(TASK-\d{3,})') { $Matches[1] } else { $Task }
$slug = $folder.Name -replace '^TASK-\d{3,}-?', ''

if ([string]::IsNullOrWhiteSpace($Branch)) {
  $Branch = "feat/$taskId-$slug"
}

$scopePath = Join-Path $folder.FullName "scope.md"
if (-not (Test-Path -LiteralPath $scopePath -PathType Leaf)) {
  throw "Missing scope.md for $($folder.Name)"
}

Set-OrAppendLine $scopePath '^- Status:' "- Status: $Status"
Set-OrAppendLine $scopePath '^- Owner:' "- Owner: $Owner"
Set-OrAppendLine $scopePath '^- Branch:' "- Branch: $Branch"

$backlogPath = Join-Path $rootPath "docs/project/backlog.md"
if (Test-Path -LiteralPath $backlogPath -PathType Leaf) {
  $lines = @(Get-Content -LiteralPath $backlogPath)
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "\|\s*$([regex]::Escape($taskId))\s*\|") {
      $parts = $lines[$i] -split '\|'
      if ($parts.Count -ge 6) {
        $parts[3] = " $Status "
        $note = $parts[5].Trim()
        if ($note -notmatch [regex]::Escape($Owner)) {
          $parts[5] = " Owner: $Owner; Branch: $Branch; $note "
        }
        $lines[$i] = ($parts -join '|')
      }
    }
  }
  Set-Content -LiteralPath $backlogPath -Value $lines -Encoding UTF8
}

& (Join-Path $rootPath ".agents/scripts/plan_team.ps1") -Root $rootPath.Path | Out-Null

Write-Host "Task claimed: $($folder.Name)"
Write-Host "Owner: $Owner"
Write-Host "Branch: $Branch"
