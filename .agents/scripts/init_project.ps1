param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

$rootPath = Resolve-Path -LiteralPath $Root

function Ensure-Dir {
  param([string]$RelativePath)

  $path = Join-Path $rootPath $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Container)) {
    New-Item -ItemType Directory -Path $path | Out-Null
  }
}

function Ensure-File {
  param(
    [string]$RelativePath,
    [string]$Content
  )

  $path = Join-Path $rootPath $RelativePath
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    $parent = Split-Path -Parent $path
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
      New-Item -ItemType Directory -Path $parent | Out-Null
    }
    Set-Content -LiteralPath $path -Value $Content -Encoding UTF8
    Write-Host "created $RelativePath"
  } else {
    Write-Host "exists  $RelativePath"
  }
}

Ensure-Dir "docs/project"
Ensure-Dir "docs/tasks"
Ensure-Dir "docs/releases"
Ensure-Dir "docs/archive"

Ensure-File "docs/project/vision.md" @"
# Vision

## Purpose

TODO: describe the project purpose.

## Users

TODO: describe who uses this project.

## Outcomes

TODO: describe the outcomes this project must deliver.
"@

Ensure-File "docs/project/scope.md" @"
# Scope

## In Scope

- TODO

## Out Of Scope

- TODO
"@

Ensure-File "docs/project/architecture.md" @"
# Architecture

## Summary

TODO: describe the system architecture.

## Main Components

- TODO

## Boundaries

- TODO
"@

Ensure-File "docs/project/database.md" @"
# Database

Status: not_assessed

## Notes

TODO: describe database model, migrations, and data constraints when applicable.
"@

Ensure-File "docs/project/api.md" @"
# API

Status: not_assessed

## Notes

TODO: describe API contracts, payloads, and integration rules when applicable.
"@

Ensure-File "docs/project/security.md" @"
# Security

Status: not_assessed

## Notes

TODO: describe authentication, authorization, secrets, and data protection rules.
"@

Ensure-File "docs/project/project_status.md" @"
# Project Status

## Current State

Status: initialized

## Active Task

None

## Last Completed Task

None

## Blockers

- None recorded.

## Next Safe Action

Create or select a task in `docs/project/backlog.md`.
"@

Ensure-File "docs/project/backlog.md" @"
# Backlog

## Tasks

| ID | Name | Status | Folder | Notes |
| --- | --- | --- | --- | --- |
"@

Ensure-File "docs/project/decision_log.md" @"
# Decision Log

## Global Decisions

No global decisions recorded yet.
"@

Ensure-File "docs/project/team_plan.md" @"
# Team Plan

## Rules

- One task per branch.
- One task per PR.
- Claim a task before implementation.
- Treat `docs/project/` as protected shared memory.

## Work Map

| Task | Status | Stage | Owner | Branch | Folder | Dependencies |
| --- | --- | --- | --- | --- | --- | --- |
"@

Write-Host "Project docs initialized."
