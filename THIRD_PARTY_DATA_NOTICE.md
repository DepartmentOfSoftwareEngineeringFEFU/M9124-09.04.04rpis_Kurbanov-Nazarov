# Third-party data notice

The project does not include Jamendo audio files.

When the user runs the dataset scripts, the software queries the Jamendo API and selects only tracks whose API response reports `audiodownload_allowed=true` and provides a non-empty `audiodownload` URL. The manifest stores the per-track Creative Commons URL returned by Jamendo.

The user is responsible for complying with each track's license and Jamendo API terms. The audio collection should be used for the stated academic/research purpose and should not be redistributed as part of this project archive.
