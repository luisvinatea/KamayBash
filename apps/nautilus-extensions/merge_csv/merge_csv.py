# pylint: disable=arguments-differ
"""
MergeCSV Nautilus extension to merge selected CSV files via an external script.
"""
import os
from urllib.parse import unquote
from typing import Any, List

# third-party imports
# pylint: disable=import-error
from gi.repository import Nautilus, GObject  # type: ignore


class MergeCSVExtension(
    GObject.GObject, Nautilus.MenuProvider  # type: ignore
):
    """Extension to merge selected CSV files in Nautilus."""

    def get_file_items(
        self,
        files: List[Any]  # Nautilus.FileInfo
    ) -> List[Any]:  # Nautilus.MenuItem
        """Return menu item if one or more CSV files are selected."""
        if not files:
            return []

        # ensure all selected items are CSV
        if not all(
            f.get_mime_type() == 'text/csv'
            or f.get_name().lower().endswith('.csv')
            for f in files
        ):
            return []

        item = Nautilus.MenuItem(  # type: ignore
            name='MergeCSVExtension::MergeCSV',
            label='Merge CSV Files',
            tip='Merge selected CSV files into a single file'
        )
        item.connect('activate', self.merge_csv_files, files)  # type: ignore
        return [item]

    def merge_csv_files(
        self,
        _menu: Any,
        files: List[Any]
    ) -> None:
        """Invoke external script to merge selected CSV files."""
        paths: List[str] = []
        for f in files:
            uri: Any = f.get_uri()
            if isinstance(uri, str) and uri.startswith('file://'):
                paths.append(unquote(str(uri[7:])))

        if not paths:
            return

        # location of the merge script
        script_path = os.path.expanduser(
            "~/.local/share/nautilus/scripts/merge_csv.sh")

        path = os.path.dirname(paths[0])
        os.system(f"{script_path} --dir '{path}'")
        file_list = ' '.join(f"'{p}'" for p in paths)
        os.system(f"{script_path} --files {file_list}")
        os.system(f"notify-send 'CSV Merge' 'Merged {len(paths)} files.'")
        print(f"Merged {len(paths)} CSV files.")
        print(f"Script path: {script_path}")
        print(f"Files to merge: {file_list}")
        print(f"Output directory: {path}")
