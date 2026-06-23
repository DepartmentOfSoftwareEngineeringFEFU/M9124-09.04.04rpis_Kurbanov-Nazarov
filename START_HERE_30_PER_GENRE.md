# Continue with 30 tracks per genre

The reduced dataset contains 18 genres x 30 tracks = 540 selected tracks.

Existing downloaded audio is reused first. Extra MP3 files already downloaded are
not deleted; they remain under `data/reference/audio`, but are excluded from the
540-track manifest and from profile training.

Run in PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

.\continue_after_shortage_18genres.ps1 `
  -ClientId "YOUR_CLIENT_ID" `
  -TracksPerGenre 30 `
  -DownloadWorkers 4 `
  -FeatureWorkers 4
```

The first step creates a full-manifest backup:

`data/reference/jamendo_18genres_tracks_full_backup.json`

and rewrites the active manifest to:

- `data/reference/jamendo_18genres_tracks.json`
- `data/reference/jamendo_18genres_tracks.csv`

The script reports how many of the 540 selected files already exist and how many
still need to be downloaded.
