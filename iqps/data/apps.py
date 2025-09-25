from django.apps import AppConfig


class DataConfig(AppConfig):
    name = 'data'

    def ready(self):
        # Connect signals (e.g., seed initial data on first migrate)
        try:
            from . import signals  # noqa: F401
        except Exception:
            # Avoid hard failures during collectstatic/migrations if imports
            # temporarily fail; Django will retry on next app load.
            pass
