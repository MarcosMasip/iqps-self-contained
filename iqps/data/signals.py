from django.db.models.signals import post_migrate
from django.dispatch import receiver

from .models import Department


DEFAULT_DEPARTMENTS = [
    "CS",  # Computer Science
    "EE",  # Electrical Engineering
    "ME",  # Mechanical Engineering
    "CE",  # Civil Engineering
    "EC",  # Electronics & Communication
    "IT",  # Information Technology
    "CH",  # Chemical Engineering
    "MT",  # Materials/Metallurgy
    "BT",  # Biotechnology
    "PH",  # Physics
    "MA",  # Mathematics
    "HS",  # Humanities
    "Other",
]


@receiver(post_migrate)
def seed_departments(sender, **kwargs):
    # Only seed when the Department table exists and is empty.
    try:
        if Department.objects.count() == 0:
            Department.objects.bulk_create(
                [Department(code=code) for code in DEFAULT_DEPARTMENTS]
            )
    except Exception:
        # If migrations are mid-flight or table doesn't exist yet, ignore.
        pass
