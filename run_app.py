from music_analyzer.db import init_db

if __name__ == "__main__":
    import uvicorn

    init_db()
    uvicorn.run("music_analyzer.app:app", host="127.0.0.1", port=8000, reload=True)
