# Продолжение после дефицита neo_soul и bebop

Теперь отдельные классы `neo_soul` и `bebop` удалены. Их музыкальные теги рассматриваются внутри родительских классов `rnb` и `jazz` при новом поиске.

Итоговая таксономия: **18 жанров × 100 треков = 1800 треков**.

## Самый быстрый путь после уже полученной ошибки

Ошибка возникла до скачивания, но программа сохранила полный JSON/CSV с 100 треками для остальных 18 жанров. Не надо повторять все API-запросы.

В корне проекта выполните:

```powershell
.\continue_after_shortage_18genres.ps1 -DownloadWorkers 4 -FeatureWorkers 4
```

Скрипт автоматически:

1. удалит `neo_soul` и `bebop` из сохранённого манифеста;
2. создаст `jamendo_18genres_tracks.json` и `.csv`;
3. отключит эти классы в SQLite;
4. скачает только 1800 выбранных файлов;
5. импортирует их в базу;
6. извлечёт признаки;
7. построит независимые профили жанров и эмоций;
8. выведет оценку качества.

Повторный запуск безопасен: уже скачанные файлы и готовые признаки пропускаются.

## Если старых файлов манифеста нет

Создайте выборку заново:

```powershell
.\build_jamendo_18genre_database.ps1 `
  -ClientId "ВАШ_CLIENT_ID" `
  -TracksPerGenre 100 `
  -DownloadWorkers 4 `
  -FeatureWorkers 4
```

## Раздельный запуск

```powershell
python scripts\filter_jamendo_manifest.py
python scripts\migrate_remove_neo_soul_bebop.py
python scripts\download_jamendo_18genre_tracks.py --workers 4
python scripts\audit_jamendo_18genre_dataset.py --audio-root data\reference\audio
python scripts\import_reference_dataset.py --manifest data\reference\jamendo_18genres_tracks.csv --audio-root data\reference\audio --strict
python scripts\extract_reference_features.py --workers 4
python scripts\build_profiles.py --task both
python scripts\evaluate_profiles.py --task both
```
