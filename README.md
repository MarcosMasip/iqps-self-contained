Intelligent Question Paper Search
=================================

An offline, self-contained platform for searching and uploading semester question papers.

This repository now supports a fully isolated, no-external-API mode by default. You can run it on macOS/Windows/Linux without Google/Dropbox credentials.

Quick Start (offline, recommended)
----------------------------------

Prerequisites:
- Docker Desktop (or Docker Engine) running
- Apple Silicon is supported; the compose pins linux/amd64 to avoid wheel issues.

Steps (copy/paste):

1) Build and start in offline mode
```zsh
docker compose -f docker-compose.offline.yml up --build -d
```
Expected outcome: Docker builds the web image and starts a container mapping http://localhost:8000.

2) Run database migrations
```zsh
docker compose -f docker-compose.offline.yml run --rm web python manage.py migrate --skip-checks
```
Expected outcome: Django applies migrations and prints "OK"/"Applying ..." output.

3) (Optional) Create a superuser to access /admin
```zsh
docker compose -f docker-compose.offline.yml run --rm web python manage.py createsuperuser
```
Expected outcome: You are prompted for username/email/password, then "Superuser created successfully".

4) Open the app
Visit http://localhost:8000

Expected outcome: The homepage loads. Uploads are stored locally in the container (MEDIA_ROOT) and served in DEBUG mode.

No Docker? Local fallback (Python venv)
--------------------------------------
If Docker isn’t available or fails, you can run locally using a virtual environment and SQLite.

Prerequisites: Python 3.8+ installed on your machine.

1) Create venv and install minimal deps
```zsh
bash scripts/dev_local.sh
```
Expected outcome: A .venv is created, minimal dependencies installed, migrations run, and the dev server starts on http://127.0.0.1:8000.

2) (Optional) Create a superuser in another terminal
```zsh
source .venv/bin/activate
cd iqps
python manage.py createsuperuser
```
Expected outcome: Credentials are created; you can log in at /admin.

Common operations
-----------------
- See logs:
```zsh
docker compose -f docker-compose.offline.yml logs -f --tail=100 web
```
- Stop:
```zsh
docker compose -f docker-compose.offline.yml down
```

Advanced (full stack, offline as well)
--------------------------------------
The legacy full-stack (nginx + gunicorn + MariaDB) flow is still available via docker-compose.yml, but no external APIs are required by default. For local development, the offline compose above is simpler and recommended.

Screenshots
-----------
![Search Interface](docs/source/_static/search.png?)

