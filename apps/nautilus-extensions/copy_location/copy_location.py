# pylint: disable=C0114,C0115,C0116,C0411,W0246,W0613,E0401,W0221
# type: ignore
"""Nautilus extension to copy file or folder location to the clipboard."""
import os
from urllib.parse import unquote
from gi.repository import Nautilus, GObject  # type: ignore


class CopyLocationExtension(GObject.GObject, Nautilus.MenuProvider):
    """Extension to add 'Copy Location' menu item in Nautilus file manager."""

    def __init__(self) -> None:
        super().__init__()

    def get_file_items(
        self,
        files: list[Nautilus.FileInfo]
    ) -> list[Nautilus.MenuItem]:
        """
        Return a list with one 'Copy Location' menu item for a single file or
        folder.
        """
        # Only show for single file/folder
        if len(files) != 1:
            return []

        item = Nautilus.MenuItem(
            name='CopyLocationExtension::CopyLocation',
            label='Copy Location',
            tip='Copy the file path to the clipboard'
        )
        item.connect('activate', self.copy_location, files)
        return [item]

    def copy_location(
        self,
        _menu: Nautilus.MenuItem,
        files: list[Nautilus.FileInfo]
    ) -> None:
        """
        Copy the selected file or folder path to clipboard and send a
        notification.
        """
        uri = files[0].get_uri()
        if uri.startswith('file://'):
            path = unquote(uri[7:])  # Remove 'file://' and decode
            os.system(f"echo -n '{path}' | xclip -selection clipboard")
            notify_cmd = (
                "notify-send 'Path Copied' "
                "'The path has been copied to the clipboard.'"
            )
            os.system(notify_cmd)
