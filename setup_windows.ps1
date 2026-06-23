$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Test-Path ".venv")) {
    python -m venv .venv
}
& ".\.venv\Scripts\python.exe" -m pip install --upgrade pip
& ".\.venv\Scripts\python.exe" -m pip install -r requirements.txt
& ".\.venv\Scripts\python.exe" scripts\init_db.py
& ".\.venv\Scripts\python.exe" scripts\verify_installation.py
Write-Host "Setup complete. Next read START_HERE_WINDOWS.md" -ForegroundColor Green
