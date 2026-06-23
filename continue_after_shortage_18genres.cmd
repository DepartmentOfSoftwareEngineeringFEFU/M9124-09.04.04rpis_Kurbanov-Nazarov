@echo off
setlocal
cd /d "%~dp0"

set "CLIENT_ID=%~1"
set "DOWNLOAD_WORKERS=%~2"
set "FEATURE_WORKERS=%~3"
set "TRACKS_PER_GENRE=%~4"
if "%CLIENT_ID%"=="" (
  echo Usage: continue_after_shortage_18genres.cmd CLIENT_ID [download_workers] [feature_workers] [tracks_per_genre]
  exit /b 2
)
if "%DOWNLOAD_WORKERS%"=="" set "DOWNLOAD_WORKERS=4"
if "%FEATURE_WORKERS%"=="" set "FEATURE_WORKERS=4"
if "%TRACKS_PER_GENRE%"=="" set "TRACKS_PER_GENRE=30"

set "PY=.venv\Scripts\python.exe"
if not exist "%PY%" (
  echo Virtual environment not found. Run setup_windows.ps1 first.
  exit /b 1
)

echo Step 1/3: reducing the saved manifest and reusing downloaded files...
"%PY%" scripts\reduce_jamendo_18genre_manifest.py --tracks-per-genre %TRACKS_PER_GENRE%
if errorlevel 1 exit /b %errorlevel%

echo Step 2/3: updating active genre classes in SQLite...
"%PY%" scripts\migrate_remove_neo_soul_bebop.py
if errorlevel 1 exit /b %errorlevel%

echo Step 3/3: completing downloads, extracting features, and building profiles...
"%PY%" scripts\run_jamendo_18genre_pipeline.py --client-id "%CLIENT_ID%" --skip-manifest --tracks-per-genre %TRACKS_PER_GENRE% --download-workers %DOWNLOAD_WORKERS% --feature-workers %FEATURE_WORKERS%
if errorlevel 1 exit /b %errorlevel%

echo Pipeline completed successfully.
endlocal
