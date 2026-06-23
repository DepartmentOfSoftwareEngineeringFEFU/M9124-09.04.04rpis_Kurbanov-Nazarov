
# Music Genre & Emotion Analyzer v6

Статистико-онтологическая система классификации музыки без нейросетей.

Главный сценарий этой версии — построение собственной эталонной базы из разрешённых к скачиванию треков Jamendo для 20 жанров, расчёт текущих 264 аудиопризнаков и построение независимых профилей жанра и эмоции.

## 20 жанров

1. pop
2. synthpop
3. rock
4. alternative_rock
5. indie_rock
6. metal
7. death_metal
8. punk
9. pop_punk
10. hiphop
11. trap
12. rnb
13. neo_soul
14. jazz
15. bebop
16. edm
17. house
18. techno
19. drum_and_bass
20. folk

## Количество треков

- `100 × 20 = 2000` треков;

## Быстрый запуск

```powershell
cd C:\music_genre_emotion_analyzer_v6
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup_windows.ps1
python scripts\verify_installation.py
```

Подробная инструкция: [`START_HERE_20_GENRES.md`](START_HERE_20_GENRES.md).

## Как формируются эталонные метки

Жанр принимается только при наличии подтверждения в `musicinfo.tags.genres`. Для родительских жанров действуют исключения, чтобы, например, `death_metal` не попал одновременно в обычный `metal`, а `pop_punk` — в обычный `punk` или `pop`.

Эмоция определяется отдельно только по фактическим `musicinfo.tags.vartags`. В JSON сохраняются исходные теги, веса, итоговый класс и качество метки. Жанр не используется при определении эмоции.

Программа выбирает только записи с `audiodownload_allowed=true` и непустым `audiodownload`.

## Основные команды

```powershell
# 1. JSON и CSV
python scripts\create_jamendo_20genre_manifest.py --client-id "ID" --tracks-per-genre 100

# 2. Скачать только выбранные треки
python scripts\download_jamendo_20genre_tracks.py --workers 4

# 3. Проверка
python scripts\audit_jamendo_20genre_dataset.py --audio-root data\reference\audio

# 4. SQLite
python scripts\init_db.py
python scripts\import_reference_dataset.py --manifest data\reference\jamendo_20genres_tracks.csv --audio-root data\reference\audio --strict

# 5. Все текущие признаки
python scripts\extract_reference_features.py --workers 4

# 6. Независимые профили
python scripts\build_profiles.py --task both

# 7. Метрики
python scripts\evaluate_profiles.py --task both

# 8. Сайт
python run_app.py
```
<img width="1280" height="720" alt="photo_2026-05-03_11-48-37" src="https://github.com/user-attachments/assets/8d619370-9b95-42f2-9363-e5eafb0b2983" />
<img width="786" height="887" alt="photo_2026-05-03_12-23-10 (2)" src="https://github.com/user-attachments/assets/ff7dc046-f2ba-4c40-a8b2-c5088cacc68d" />
<img width="1280" height="721" alt="photo_2026-06-08_00-16-13 (3)" src="https://github.com/user-attachments/assets/82977cee-4e48-474a-b2d3-3c5e1bb966ba" />
<img width="709" height="644" alt="photo_2026-06-08_00-16-13 (2)" src="https://github.com/user-attachments/assets/b3e23085-162a-444e-b17c-4f34b28e4417" />
