"""Merge PPT Extension for Nautilus
This extension allows users to merge selected PPT and PPTX files into a
single file using an external script. It integrates with the Nautilus file
manager to provide a context menu option for merging PPT files.
"""
# pylint: disable=import-error,arguments-differ

import os
from typing import Any, List
from urllib.parse import unquote
from gi.repository import Nautilus, GObject  # type: ignore


class MergePPTExtension(
    GObject.GObject,  # type: ignore
    Nautilus.MenuProvider,  # type: ignore
):
    """Extension to merge selected PPT and PPTX files in Nautilus."""

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
        # Show only when one or more PPT/PPTX files are selected
        if not files or not all(
            self._is_presentation_document(f) for f in files
        ):
            return []

        item = Nautilus.MenuItem(  # type: ignore
            name='MergePPTExtension::MergePPT',
            label='Merge PPT Files',
            tip='Merge selected PPT and PPTX files into a single file'
        )
        item.connect('activate', self.merge_ppt_files, files)  # type: ignore
        return [item]

    def _is_presentation_document(self, file_info: Any) -> bool:
        """Check if the file is a PowerPoint presentation (PPT/PPTX)."""
        mime_type = file_info.get_mime_type()
        filename = file_info.get_name().lower()
        return (
            mime_type in (
                'application/vnd.ms-powerpoint',
                'application/vnd.openxmlformats-'
                'officedocument.presentationml.presentation'
            ) or filename.endswith(('.ppt', '.pptx'))
        )

    def merge_ppt_files(
        self, _menu: Any, files: List[Any]
    ) -> None:
        """
        Invoke external script to merge selected PPT and PPTX files.

        Args:
            _menu: Ignored menu parameter
            files: List of selected file items
        """
        paths = self._get_file_paths(files)
        if not paths:
            return

        script_path = os.path.expanduser(
            "~/.local/share/nautilus/scripts/merge_ppt.sh")

        output_dir = os.path.dirname(paths[0])
        file_list = ' '.join(f"'{p}'" for p in paths)

        # Execute merge commands
        os.system(f"{script_path} --dir '{output_dir}'")
        os.system(f"{script_path} --files {file_list}")

        # Notify user
        os.system(f"notify-send 'PPT Merge' 'Merged {len(paths)} files.'")

        # Debug output
        print(f"Merged {len(paths)} PPT files.")
        print(f"Script path: {script_path}")
        print(f"Files to merge: {file_list}")
        print(f"Output directory: {output_dir}")

    def _get_file_paths(self, files: List[Any]) -> List[str]:
        """Extract file paths from Nautilus file items."""
        paths: List[str] = []
        for file in files:
            uri = file.get_uri()
            if uri.startswith('file://'):
                # Remove 'file://' and decode
                decoded_path = str(unquote(uri[7:]))
                paths.append(decoded_path)
        return paths
