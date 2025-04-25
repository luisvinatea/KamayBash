# KamayBash

KamayBash ("Tool" in Quechua) is a collection of Bash and Python scripts designed to automate repetitive file management tasks in Linux via Nautilus context menu extensions. It simplifies tasks like merging files, flattening folder structures, and organizing files by extension, making your workflow more efficient.

## Features

- **Copy Location**: Copy file or folder paths to the clipboard.
- **Merge CSV**: Combine multiple CSV files into a single file.
- **Merge PDF**: Merge PDF files using `pdfunite`.
- **Merge DOC**: Merge DOC/DOCX files using `pandoc`.
- **Merge PPT**: Merge PPT/PPTX files via PDF conversion with `unoconv`.
- **Flatten Folder**: Move all files from subdirectories to the root folder.
- **Organize by Extension**: Sort files into subdirectories based on their lowercase extensions.

## Prerequisites

Before installing, ensure you have the following dependencies installed on your Linux system (Ubuntu/Debian-based):

```bash
sudo apt update
sudo apt install -y python3-nautilus python3-gi libnotify-bin pdfunite pandoc unoconv
```

- `python3-nautilus`: Enables Nautilus Python extensions.
- `python3-gi`: Provides `PyGObject` for Nautilus integration.
- `libnotify-bin`: Supports desktop notifications.
- `pdfunite`: Required for `merge_pdf`.
- `pandoc`: Required for `merge_doc`.
- `unoconv`: Required for `merge_ppt`.

Additionally, install Python dependencies:

```bash
pip install PyGObject
```

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/luisvinatea/KamayBash.git
   cd KamayBash
   ```

2. **Copy Python Extensions**:
   Copy the Python scripts to the Nautilus Python extensions directory:

   ```bash
   mkdir -p ~/.local/share/nautilus-python/extensions
   cp apps/nautilus-extensions/*/copy_location.py ~/.local/share/nautilus-python/extensions/
   cp apps/nautilus-extensions/*/flatten_folder.py ~/.local/share/nautilus-python/extensions/
   cp apps/nautilus-extensions/*/merge_csv.py ~/.local/share/nautilus-python/extensions/
   cp apps/nautilus-extensions/*/merge_doc.py ~/.local/share/nautilus-python/extensions/
   cp apps/nautilus-extensions/*/merge_pdf.py ~/.local/share/nautilus-python/extensions/
   cp apps/nautilus-extensions/*/merge_ppt.py ~/.local/share/nautilus-python/extensions/
   cp apps/nautilus-extensions/*/organize_by_extension.py ~/.local/share/nautilus-python/extensions/
   ```

3. **Copy Bash Scripts**:
   Copy the Bash scripts to the Nautilus scripts directory:

   ```bash
   mkdir -p ~/.local/share/nautilus/scripts
   cp apps/nautilus-extensions/*/flatten_folder.sh ~/.local/share/nautilus/scripts/
   cp apps/nautilus-extensions/*/merge_csv.sh ~/.local/share/nautilus/scripts/
   cp apps/nautilus-extensions/*/merge_doc.sh ~/.local/share/nautilus/scripts/
   cp apps/nautilus-extensions/*/merge_pdf.sh ~/.local/share/nautilus/scripts/
   cp apps/nautilus-extensions/*/merge_ppt.sh ~/.local/share/nautilus/scripts/
   cp apps/nautilus-extensions/*/organize_by_extension.sh ~/.local/share/nautilus/scripts/
   ```

4. **Make Bash Scripts Executable**:
   Ensure the Bash scripts are executable:

   ```bash
   chmod +x ~/.local/share/nautilus/scripts/*.sh
   ```

5. **Restart Nautilus**:
   Reload Nautilus to apply the extensions:

   ```bash
   nautilus -q
   ```

## Testing

1. Open Nautilus (Files) in your Linux desktop environment.
2. Right-click on a file or folder:
   - Select **Copy Location** to copy the path to the clipboard.
   - Navigate to **Scripts** > select a script (e.g., `merge_csv.sh`, `flatten_folder.sh`) to run it on selected files.
3. For file merging (e.g., CSV, PDF, DOC, PPT), select multiple files, right-click, and choose the corresponding script from the **Scripts** menu.
4. Check for desktop notifications (via `libnotify-bin`) to confirm actions (e.g., “Files merged successfully”).

## Documentation

Explore the full documentation at [KamayBash Docs](https://luisvinatea.github.io/KamayBash/).

To build the documentation locally:

```bash
cd docs
pip install sphinx sphinx-rtd-theme
make html
xdg-open _build/html/index.html
```

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on reporting issues, submitting pull requests, and coding standards.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
