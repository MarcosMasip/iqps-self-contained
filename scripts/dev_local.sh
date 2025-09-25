#!/usr/bin/env bash
set -euo pipefail

PY=${PY:-python3}
VENV=.venv

echo "[local] Setting up virtual environment in ${VENV}"
${PY} -m venv ${VENV}
source ${VENV}/bin/activate

python -m pip install --upgrade pip wheel
python -m pip install -r requirements.runtime.txt

echo "[local] Applying migrations (SQLite)"
cd iqps
export MODE=dev
export LOGIN_REQUIRED=True

${PY} manage.py migrate --skip-checks

echo "[local] Create a superuser (optional). To do so now, press Ctrl+C after and run:"
echo "       source ${VENV}/bin/activate && cd iqps && python manage.py createsuperuser"

echo "[local] Starting Django dev server at http://127.0.0.1:8000"
${PY} manage.py runserver 127.0.0.1:8000
