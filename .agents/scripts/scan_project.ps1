param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root
$docsProject = Join-Path $rootPath "docs/project"

if (-not (Test-Path -LiteralPath $docsProject -PathType Container)) {
  New-Item -ItemType Directory -Path $docsProject -Force | Out-Null
}

$ignoredDirs = @(
  ".git",
  ".agents",
  "node_modules",
  "vendor",
  "dist",
  "build",
  ".next",
  ".nuxt",
  "coverage",
  "target",
  "bin",
  "obj",
  ".venv",
  "venv",
  "__pycache__"
)

function Get-RelativePath {
  param([string]$Path)

  $full = (Resolve-Path -LiteralPath $Path).Path
  return $full.Substring($rootPath.Path.Length + 1).Replace("\", "/")
}

function Test-IgnoredPath {
  param([string]$Path)

  $relative = Get-RelativePath $Path
  foreach ($dir in $ignoredDirs) {
    if ($relative -eq $dir -or $relative.StartsWith("$dir/") -or $relative -like "*/$dir/*") {
      return $true
    }
  }
  return $false
}

function Get-InterestingFiles {
  $all = Get-ChildItem -LiteralPath $rootPath -Recurse -File -Force |
    Where-Object { -not (Test-IgnoredPath $_.FullName) }
  return @($all)
}

function Select-ByName {
  param(
    [object[]]$Files,
    [string[]]$Names
  )

  return @($Files | Where-Object { $Names -contains $_.Name })
}

function Select-ByExtension {
  param(
    [object[]]$Files,
    [string[]]$Extensions
  )

  return @($Files | Where-Object { $Extensions -contains $_.Extension.ToLowerInvariant() })
}

function Get-TopDirs {
  param([object[]]$Files)

  $dirs = @{}
  foreach ($file in $Files) {
    $relative = Get-RelativePath $file.FullName
    $parts = $relative -split "/"
    $top = if ($parts.Count -gt 1) { $parts[0] } else { "(root files)" }
    if (-not [string]::IsNullOrWhiteSpace($top)) {
      if (-not $dirs.ContainsKey($top)) {
        $dirs[$top] = 0
      }
      $dirs[$top]++
    }
  }
  return $dirs.GetEnumerator() | Sort-Object Name
}

function Get-Heading {
  param([string]$Path)

  try {
    $lines = Get-Content -LiteralPath $Path -TotalCount 40
    foreach ($line in $lines) {
      if ($line -match '^\s*#\s+(.+)$') {
        return $Matches[1].Trim()
      }
    }
    foreach ($line in $lines) {
      if (-not [string]::IsNullOrWhiteSpace($line)) {
        return $line.Trim()
      }
    }
  } catch {
    return ""
  }
  return ""
}

function Write-List {
  param(
    [System.Text.StringBuilder]$Builder,
    [string]$Title,
    [object[]]$Items,
    [int]$Limit = 50
  )

  [void]$Builder.AppendLine("## $Title")
  [void]$Builder.AppendLine("")
  if ($Items.Count -eq 0) {
    [void]$Builder.AppendLine("- None detected.")
  } else {
    foreach ($item in ($Items | Select-Object -First $Limit)) {
      [void]$Builder.AppendLine("- $item")
    }
    if ($Items.Count -gt $Limit) {
      [void]$Builder.AppendLine("- ... $($Items.Count - $Limit) more")
    }
  }
  [void]$Builder.AppendLine("")
}

$files = Get-InterestingFiles
$markdown = Select-ByExtension $files @(".md", ".mdx", ".rst", ".txt")
$canonicalProjectDocs = @(
  "docs/project/vision.md",
  "docs/project/scope.md",
  "docs/project/architecture.md",
  "docs/project/database.md",
  "docs/project/api.md",
  "docs/project/security.md",
  "docs/project/project_status.md",
  "docs/project/backlog.md",
  "docs/project/decision_log.md",
  "docs/project/onboarding_research.md",
  "docs/project/code_map.md"
)
function Test-CanonicalProjectDoc {
  param([string]$Path)

  $rel = Get-RelativePath $Path
  return $canonicalProjectDocs -contains $rel
}
$nonCanonicalMarkdown = @($markdown | Where-Object {
  $rel = Get-RelativePath $_.FullName
  -not ($canonicalProjectDocs -contains $rel)
})
$manifests = Select-ByName $files @(
  "package.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  "package-lock.json",
  "requirements.txt",
  "pyproject.toml",
  "poetry.lock",
  "Pipfile",
  "go.mod",
  "go.sum",
  "Cargo.toml",
  "Cargo.lock",
  "pom.xml",
  "build.gradle",
  "settings.gradle",
  "composer.json",
  "Gemfile",
  "Makefile",
  "Dockerfile",
  "docker-compose.yml",
  "compose.yml",
  "tsconfig.json",
  "vite.config.ts",
  "next.config.js",
  "next.config.mjs"
)

$sourceExtensions = @(".js", ".jsx", ".ts", ".tsx", ".py", ".go", ".rs", ".java", ".cs", ".php", ".rb", ".kt", ".swift", ".vue", ".svelte")
$sourceFiles = Select-ByExtension $files $sourceExtensions
$testFiles = @($sourceFiles | Where-Object {
  $rel = Get-RelativePath $_.FullName
  $rel -match '(^|/)(test|tests|spec|specs|__tests__)(/|$)' -or $_.Name -match '\.(test|spec)\.'
})
$dbFiles = @($files | Where-Object {
  $rel = Get-RelativePath $_.FullName
  (-not (Test-CanonicalProjectDoc $_.FullName)) -and $rel -match '(migration|migrations|schema|database|prisma|sequelize|typeorm|supabase|sql)'
})
$ciFiles = @($files | Where-Object {
  $rel = Get-RelativePath $_.FullName
  $rel -match '(^|/)(\.github/workflows|\.gitlab-ci|azure-pipelines|Jenkinsfile|circleci|\.circleci)(/|$)' -or $_.Name -match '^(Dockerfile|docker-compose\.yml|compose\.yml)$'
})
$envFiles = @($files | Where-Object {
  $_.Name -match '^\.env(\..*)?$|\.env\.example|\.env\.sample' -or $_.Name -match 'secret|secrets'
})
$activeWorkClues = @()
foreach ($file in @(@($sourceFiles) + @($nonCanonicalMarkdown))) {
  try {
    $matches = Select-String -LiteralPath $file.FullName -Pattern 'TODO|FIXME|HACK|WIP|incomplete|pendente|bug|deprecated' -CaseSensitive:$false -ErrorAction SilentlyContinue |
      Select-Object -First 5
    foreach ($match in $matches) {
      $activeWorkClues += "$(Get-RelativePath $file.FullName):$($match.LineNumber) - $($match.Line.Trim())"
    }
  } catch {
  }
}

$research = New-Object System.Text.StringBuilder
[void]$research.AppendLine("# Onboarding Research")
[void]$research.AppendLine("")
[void]$research.AppendLine("Generated by `.agents/scripts/scan_project.ps1`.")
[void]$research.AppendLine("")
[void]$research.AppendLine("## Purpose")
[void]$research.AppendLine("")
[void]$research.AppendLine("This file captures repository facts discovered during onboarding. It is evidence for reconstructing an existing project before creating pipeline tasks.")
[void]$research.AppendLine("")
[void]$research.AppendLine("## Repository Snapshot")
[void]$research.AppendLine("")
[void]$research.AppendLine("- Total scanned files: $($files.Count)")
[void]$research.AppendLine("- Source files detected: $($sourceFiles.Count)")
[void]$research.AppendLine("- Test files detected: $($testFiles.Count)")
[void]$research.AppendLine("- Non-canonical markdown/text docs detected: $($nonCanonicalMarkdown.Count)")
[void]$research.AppendLine("")

$topDirs = @(Get-TopDirs $files | ForEach-Object { "$($_.Name) ($($_.Value) files)" })
Write-List $research "Top-Level Directories" $topDirs 100

$docItems = @($nonCanonicalMarkdown | ForEach-Object {
  $rel = Get-RelativePath $_.FullName
  $heading = Get-Heading $_.FullName
  if ([string]::IsNullOrWhiteSpace($heading)) {
    $rel
  } else {
    "$rel - $heading"
  }
})
Write-List $research "Existing Non-Canonical Documentation Found" $docItems 100

Write-List $research "Manifests And Project Config" (@($manifests | ForEach-Object { Get-RelativePath $_.FullName })) 100
Write-List $research "Likely Test Files" (@($testFiles | ForEach-Object { Get-RelativePath $_.FullName })) 100
Write-List $research "Database Or Migration Clues" (@($dbFiles | ForEach-Object { Get-RelativePath $_.FullName })) 100
Write-List $research "CI, Deploy, Or Container Clues" (@($ciFiles | ForEach-Object { Get-RelativePath $_.FullName })) 100
Write-List $research "Environment Or Secret Clues" (@($envFiles | ForEach-Object { Get-RelativePath $_.FullName })) 100
Write-List $research "Potential Active Or Incomplete Work Clues" $activeWorkClues 150

[void]$research.AppendLine("## Onboarding Interpretation")
[void]$research.AppendLine("")
[void]$research.AppendLine("Codex must fill this section after reading the evidence above and inspecting relevant files.")
[void]$research.AppendLine("")
[void]$research.AppendLine("- Project type:")
[void]$research.AppendLine("- Main runtime/framework:")
[void]$research.AppendLine("- Main modules:")
[void]$research.AppendLine("- Current implemented capabilities:")
[void]$research.AppendLine("- Existing docs that should be migrated or referenced:")
[void]$research.AppendLine("- Likely active/incomplete work:")
[void]$research.AppendLine("- Risks or unknowns:")
[void]$research.AppendLine("")

$codeMap = New-Object System.Text.StringBuilder
[void]$codeMap.AppendLine("# Code Map")
[void]$codeMap.AppendLine("")
[void]$codeMap.AppendLine("Generated by `.agents/scripts/scan_project.ps1`.")
[void]$codeMap.AppendLine("")
Write-List $codeMap "Top-Level Directories" $topDirs 100
Write-List $codeMap "Source Files Sample" (@($sourceFiles | ForEach-Object { Get-RelativePath $_.FullName })) 150
Write-List $codeMap "Tests Sample" (@($testFiles | ForEach-Object { Get-RelativePath $_.FullName })) 150
Write-List $codeMap "Config And Manifests" (@($manifests | ForEach-Object { Get-RelativePath $_.FullName })) 100

$researchPath = Join-Path $docsProject "onboarding_research.md"
$codeMapPath = Join-Path $docsProject "code_map.md"

Set-Content -LiteralPath $researchPath -Value $research.ToString() -Encoding UTF8
Set-Content -LiteralPath $codeMapPath -Value $codeMap.ToString() -Encoding UTF8

Write-Host "Project scan complete."
Write-Host "created docs/project/onboarding_research.md"
Write-Host "created docs/project/code_map.md"
