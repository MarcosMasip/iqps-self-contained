import os
import shutil
from django.conf import settings


class LocalStorage:
    """Local filesystem storage used for fully offline mode.

    We mimic the minimal interface used by views: get_or_create_folder and upload_file,
    returning a "link" that can be stored in the DB. For simplicity, the link is a
    local relative path under MEDIA_ROOT which can be served in DEBUG via Django.
    """

    def get_or_create_folder(self, remote_name, public=False):
        folder_path = os.path.join(settings.MEDIA_ROOT, remote_name)
        os.makedirs(folder_path, exist_ok=True)
        return folder_path  # act as folder id/path

    def upload_file(self, local_path, remote_name, folderId=None):
        target_dir = folderId or settings.MEDIA_ROOT
        os.makedirs(target_dir, exist_ok=True)
        dest_path = os.path.join(target_dir, remote_name)
        # Move or copy to keep semantics similar to remote upload
        shutil.move(local_path, dest_path)
        # return a relative link under MEDIA_URL for app consumption
        rel_path = os.path.relpath(dest_path, settings.MEDIA_ROOT)
        return settings.MEDIA_URL.rstrip('/') + '/' + rel_path.replace('\\', '/')


def get_storage():
    backend = os.environ.get('STORAGE_BACKEND', 'local').lower()
    # For now only local is supported in self-contained mode; gdrive path stays unused.
    return LocalStorage()
