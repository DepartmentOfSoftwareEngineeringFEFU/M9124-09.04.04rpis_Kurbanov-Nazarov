param(
    [Parameter(Mandatory=$true)][string]$ClientId,
    [int]$TracksPerGenre = 100,
    [int]$DownloadWorkers = 4,
    [int]$FeatureWorkers = 4,
    [switch]$AllowShortages
)

$ErrorActionPreference = "Stop"
$python = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $python)) {
    throw "Виртуальное окружение не найдено. Сначала выполните .\setup_windows.ps1"
}

$argsList = @(
    "scripts\run_jamendo_20genre_pipeline.py",
    "--client-id", $ClientId,
    "--tracks-per-genre", $TracksPerGenre,
    "--download-workers", $DownloadWorkers,
    "--feature-workers", $FeatureWorkers
)
if ($AllowShortages) { $argsList += "--allow-shortages" }

& $python @argsList
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
