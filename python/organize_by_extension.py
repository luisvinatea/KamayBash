"""Organize by Extension Extension for Nautilus
This extension allows users to organize files in a selected folder by their
file extensions, moving each file to a lowercase subdirectory named after its
extension. It integrates with the Nautilus file manager to provide a context
menu option.
"""
# pylint: disable=import-error,arguments-differ

import os
from typing import Any, List
from urllib.parse import unquote
from gi.repository import Nautilus, GObject  # type: ignore


class OrganizeByExtensionExtension(
    GObject.GObject,  # type: ignore
    Nautilus.MenuProvider,  # type: ignore
):
    """Extension to organize files by extension in Nautilus."""

    def get_file_items(
        self,
        _window: Any,
        files: List[Any]
    ) -> List[Any]:
        """
        Return a list of menu items for the selected files.

        Args:
            _window: Ignored window parameter
            files: List of selected file items

        Returns:
            List of menu items to display
        """
        # Show only when exactly one folder is selected
        if len(files) != 1 or not files[0].is_directory():
            return []

        item = Nautilus.MenuItem(  # type: ignore
            name='OrganizeByExtensionExtension::OrganizeByExtension',
            label='Organize by Extension',
            tip=('Move files to lowercase subdirectories named after their '
                 'extensions')
        )
        item.connect(  # type: ignore
            'activate',
            self.organize_by_extension,
            files
        )
        return [item]

    def organize_by_extension(
        self,
        _menu: Any,
        files: List[Any]
    ) -> None:
        """
        Invoke external script to organize files by extension.

        Args:
            _menu: Ignored menu parameter
            files: List of selected file items
        """
        path = self._get_folder_path(files[0])
        if not path:
            return

        script_path = os.path.expanduser(
            "~/.local/share/nautilus/scripts/desktop/organize_by_extension.sh"
        )
        os.system(f"{script_path} --dir '{path}'")

    def _get_folder_path(self, file_info: Any) -> str:
        """
        Extract folder path from Nautilus file item.

        Args:
            file_info: The Nautilus file item

        Returns:
            The decoded file path or empty string if invalid
        """
        uri = file_info.get_uri()
        if uri.startswith('file://'):
            return str(unquote(uri[7:]))  # Remove 'file://' and decode
        return ""
