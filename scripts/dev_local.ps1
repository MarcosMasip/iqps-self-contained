# Windows PowerShell local dev script
param(
  [string]$Py = "python"
)

$ErrorActionPreference = "Stop"

$venv = ".venv"
Write-Host "[local] Setting up virtual environment in $venv"
& $Py -m venv $venv
. "$venv/Scripts/Activate.ps1"

python -m pip install --upgrade pip wheel
python -m pip install -r requirements.runtime.txt

Write-Host "[local] Applying migrations (SQLite)"
Set-Location iqps
$env:MODE = "dev"
$env:LOGIN_REQUIRED = "True"

python manage.py migrate --skip-checks

Write-Host "[local] Starting Django dev server at http://127.0.0.1:8000"
python manage.py runserver 127.0.0.1:8000
