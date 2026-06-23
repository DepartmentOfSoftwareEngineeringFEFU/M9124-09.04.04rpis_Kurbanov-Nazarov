# Test report — v6

Date: 2026-06-07

## Automated tests

```text
12 passed
```

Covered:

- 264-feature extractor;
- database and web routes;
- duplicate upload update behavior;
- statistical ontology profile behavior;
- 20-genre configuration integrity;
- genre evidence and parent/subgenre exclusions;
- emotion mapping from real Jamendo `vartags`;
- download permission filtering;
- deterministic artist-separated data split.

## Installation verification

`python scripts/verify_installation.py` completed with `ok: true`, 265 numeric outputs (264 classification features plus sample rate), BPM detection and six visualizations.

## Not executed in this environment

Live Jamendo API selection and audio download were not executed because the API requires a user-specific `client_id`. The code handles API errors, retries, incomplete classes, resumable downloads, checksums and audit reporting.
