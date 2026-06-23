# База Jamendo: 20 жанров × N треков

## Важная арифметика

В списке 20 жанров. Поэтому:

- 100 треков на жанр = **2000 треков**;
- 75 треков на жанр = **1500 треков**.

Программа поддерживает оба режима параметром `--tracks-per-genre`.

## Что делает программа

1. Запрашивает Jamendo API по каждому из 20 жанров.
2. Оставляет только треки, у которых автор разрешил скачивание (`audiodownload_allowed=true`).
3. Проверяет жанр по фактическим `musicinfo.tags.genres`, а не только по поисковому запросу.
4. Определяет эталонную эмоцию только по фактическим `musicinfo.tags.vartags`.
5. Исключает один и тот же трек из нескольких классов.
6. Ограничивает число треков одного исполнителя.
7. Создаёт JSON и CSV с доказательствами жанра и эмоции.
8. Скачивает только выбранные файлы.
9. Импортирует их в SQLite.
10. Извлекает 264 признака текущим `features.py`.
11. Строит независимые профили жанров и эмоций.
12. Оценивает качество на artist-separated train/validation/test.

## Подготовка

```powershell
cd C:\music_genre_emotion_analyzer_v6
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup_windows.ps1
python scripts\verify_installation.py
```

Нужны:

- Python 3.11/3.12;
- FFmpeg в PATH;
- Jamendo Client ID из Jamendo Developer Portal;
- свободное место на диске.

## Вариант A: 100 на каждый жанр = 2000

```powershell
.\build_jamendo_20genre_database.ps1 `
  -ClientId "ВАШ_CLIENT_ID" `
  -TracksPerGenre 100 `
  -DownloadWorkers 4 `
  -FeatureWorkers 4
```

## Вариант B: ровно 1500 = 75 на каждый жанр

```powershell
.\build_jamendo_20genre_database.ps1 `
  -ClientId "ВАШ_CLIENT_ID" `
  -TracksPerGenre 75 `
  -DownloadWorkers 4 `
  -FeatureWorkers 4
```

## По шагам

### 1. Создать JSON/CSV

```powershell
python scripts\create_jamendo_20genre_manifest.py `
  --client-id "ВАШ_CLIENT_ID" `
  --tracks-per-genre 100
```

Файлы:

```text
data\reference\jamendo_20genres_tracks.json
data\reference\jamendo_20genres_tracks.csv
```

Если хотя бы по одному жанру не найдено нужное число разрешённых и реально размеченных треков, строгий режим остановит процесс и сохранит отчёт о дефиците. Программа не подделывает отсутствующие жанры.

### 2. Скачать только выбранные треки

```powershell
python scripts\download_jamendo_20genre_tracks.py --workers 4
```

Аудио сохранится так:

```text
data\reference\audio\pop\<track_id>.mp3
data\reference\audio\synthpop\<track_id>.mp3
...
```

Повторный запуск продолжает загрузку и не скачивает готовые файлы заново.

### 3. Проверить выборку

```powershell
python scripts\audit_jamendo_20genre_dataset.py `
  --audio-root data\reference\audio
```

### 4. Импортировать в SQLite

```powershell
python scripts\init_db.py
python scripts\import_reference_dataset.py `
  --manifest data\reference\jamendo_20genres_tracks.csv `
  --audio-root data\reference\audio `
  --strict
```

### 5. Получить признаки

Сначала 10 треков:

```powershell
python scripts\extract_reference_features.py --workers 2 --limit 10
```

Затем остальные:

```powershell
python scripts\extract_reference_features.py --workers 4
```

Повторный запуск продолжает с необработанных файлов.

### 6. Построить профили

```powershell
python scripts\build_profiles.py --task both
```

### 7. Оценить качество

```powershell
python scripts\evaluate_profiles.py --task both
```

### 8. Запустить сайт

```powershell
python run_app.py
```

Открыть `http://127.0.0.1:8000`.

## Что находится в JSON

Для каждого трека сохраняются:

- Jamendo ID;
- название, исполнитель, альбом, дата;
- эталонный жанр;
- эталонная эмоция;
- реальные исходные genre/vartags;
- доказательство назначения класса;
- качество метки;
- Creative Commons URL;
- разрешение на скачивание;
- URL скачивания;
- train/validation/test split;
- локальный путь, checksum и статус загрузки.

## Ограничение

Jamendo может не иметь 100 разрешённых и однозначно размеченных треков для узких классов вроде `bebop`, `neo_soul` или `death_metal`. В этом случае программа покажет реальный дефицит. Не рекомендуется включать `--allow-shortages` для итогового эксперимента, пока классы не сбалансированы.
