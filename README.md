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

One-command start (choose either Docker or Local):

- Docker (macOS/Windows/Linux):
	```zsh
	docker compose -f docker-compose.offline.yml up --build -d && \
	docker compose -f docker-compose.offline.yml run --rm web python manage.py migrate --skip-checks && \
	echo "Open http://localhost:8000"
	```
	Expected outcome: Image builds, container starts, migrations apply, and the app is reachable at http://localhost:8000.

- Local (no Docker; macOS/Linux):
	```zsh
	bash scripts/dev_local.sh
	```
	Expected outcome: A .venv is created, minimal deps are installed, migrations run, and the server starts at http://127.0.0.1:8000.

- Local (no Docker; Windows PowerShell):
	```powershell
	.\scripts\dev_local.ps1
	```
	Expected outcome: A .venv is created, minimal deps are installed, migrations run, and the server starts at http://127.0.0.1:8000.

Initial data and departments
----------------------------
- Departments are auto-seeded on first run (post-migrate signal) with common codes like CS, EE, ME, … and "Other". If the table is empty, they will be created automatically.
- The local scripts also load a tiny sample fixture (`iqps/fixtures/sample.json`) to ensure at least one department exists.
- To add more departments manually:
	```zsh
	# via admin (easiest)
	open http://127.0.0.1:8000/admin  # or http://localhost:8000/admin in Docker
	# or via shell
	source .venv/bin/activate && cd iqps && python manage.py shell -c "from data.models import Department as D; [D.objects.get_or_create(code=c) for c in ['CSE','BIO','AERO']]"
	```

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

Stop and cleanup
----------------

- Docker (macOS/Windows/Linux):
	- Stop the app (keeps image):
		```zsh
		docker compose -f docker-compose.offline.yml down
		```
	- Full cleanup (stop and remove container, image, and any named volumes):
		```zsh
		docker compose -f docker-compose.offline.yml down --rmi local --volumes
		```

- Local (no Docker; macOS/Linux):
	- Stop the dev server: press Ctrl+C in the terminal running `scripts/dev_local.sh`.
	- Optional cleanup (remove venv, local DB, logs, and uploaded media):
		```zsh
		rm -rf .venv
		rm -f iqps/db.sqlite3
		rm -rf iqps/logs
		rm -rf iqps/media
		```

- Local (no Docker; Windows PowerShell):
	- Stop the dev server: press Ctrl+C in the terminal running `scripts\dev_local.ps1`.
	- Optional cleanup (remove venv, local DB, logs, and uploaded media):
		```powershell
		Remove-Item -Recurse -Force .venv
		Remove-Item -Force iqps\db.sqlite3 -ErrorAction SilentlyContinue
		Remove-Item -Recurse -Force iqps\logs -ErrorAction SilentlyContinue
		Remove-Item -Recurse -Force iqps\media -ErrorAction SilentlyContinue
		```

