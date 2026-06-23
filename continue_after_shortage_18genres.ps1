param(
    [Parameter(Mandatory=$true)][string]$ClientId,
    [int]$TracksPerGenre = 30,
    [int]$DownloadWorkers = 4,
    [int]$FeatureWorkers = 4
)
$ErrorActionPreference = "Stop"
$python = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $python)) { throw "Virtual environment not found. Run setup_windows.ps1 first." }

Write-Host "Step 1/3: reducing the saved manifest and reusing downloaded files..." -ForegroundColor Cyan
& $python "scripts\reduce_jamendo_18genre_manifest.py" `
    "--tracks-per-genre" $TracksPerGenre
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Step 2/3: updating active genre classes in SQLite..." -ForegroundColor Cyan
& $python "scripts\migrate_remove_neo_soul_bebop.py"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Step 3/3: completing downloads, extracting features, and building profiles..." -ForegroundColor Cyan
& $python "scripts\run_jamendo_18genre_pipeline.py" `
    "--client-id" $ClientId `
    "--skip-manifest" `
    "--tracks-per-genre" $TracksPerGenre `
    "--download-workers" $DownloadWorkers `
    "--feature-workers" $FeatureWorkers
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
