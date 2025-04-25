"""Flatten Folder Extension for Nautilus
This extension allows users to flatten a selected folder by moving all files
from subdirectories to the root level and deleting empty subdirectories.
It integrates with the Nautilus file manager to provide a context menu option.
It is designed to work with Nautilus 3.0 and later versions.
"""
# pylint: disable=import-error

import os
from typing import Any, List
from urllib.parse import unquote
from gi.repository import Nautilus, GObject  # type: ignore


class FlattenFolderExtension(
    GObject.GObject,  # type: ignore
    Nautilus.MenuProvider,  # type: ignore
):
    """Extension to flatten a selected folder in Nautilus."""

    def get_file_items(self, _window: Any, files: List[Any]) -> List[Any]:
        # pylint: disable=arguments-differ
        """Return a list of menu items for the selected files."""

        # Show only when exactly one folder is selected
        if len(files) != 1 or not files[0].is_directory():
            return []

        item = Nautilus.MenuItem(  # type: ignore
            name='FlattenFolderExtension::FlattenFolder',
            label='Flatten Folder',
            tip=(
                'Move all files from subdirectories to the root folder '
                'and delete empty subdirectories'
            )
        )
        item.connect('activate', self.flatten_folder, files)  # type: ignore
        return [item]

    def flatten_folder(self, _menu: Any, files: List[Any]) -> None:
        """Invoke external script to flatten the selected folder."""
        # Convert Nautilus file URI to path
        uri = files[0].get_uri()
        if not uri.startswith('file://'):
            return

        path = unquote(uri[7:])  # Remove 'file://' and decode

        # Path to flatten_folder.sh
        script_path = os.path.expanduser(
            "~/.local/share/nautilus/scripts/desktop/flatten_folder.sh"
        )
        os.system(f"{script_path} --dir '{path}'")
