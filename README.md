Intelligent Question Paper Search
=================================

An offline, self-contained platform for searching and uploading semester question papers.

This repository now supports a fully isolated, no-external-API mode by default. You can run it on macOS/Windows/Linux without Google/Dropbox credentials.

Quick Start (offline, recommended)
----------------------------------

Prerequisites:
- Docker Desktop (or Docker Engine) running
- Optional on Apple Silicon: export DOCKER_DEFAULT_PLATFORM=linux/amd64

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

