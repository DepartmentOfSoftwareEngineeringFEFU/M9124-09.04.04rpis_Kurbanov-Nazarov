param(
    [Parameter(Mandatory=$true)][string]$ClientId,
    [int]$TracksPerGenre = 30,
    [int]$DownloadWorkers = 4,
    [int]$FeatureWorkers = 4
)
$ErrorActionPreference = "Stop"
$python = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $python)) { throw "Не найдено .venv. Сначала выполните .\setup_windows.ps1" }
& $python "scripts\migrate_remove_neo_soul_bebop.py"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $python "scripts\run_jamendo_18genre_pipeline.py" `
  "--client-id" $ClientId `
  "--tracks-per-genre" $TracksPerGenre `
  "--download-workers" $DownloadWorkers `
  "--feature-workers" $FeatureWorkers
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
