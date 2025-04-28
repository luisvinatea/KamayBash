# KamayBash

KamayBash ("To Create" in Quechua) is a collection of Bash and Python scripts designed to automate repetitive file management tasks in Linux via Nautilus context menu extensions. It simplifies tasks like merging files, flattening folder structures, and organizing files by extension, making your workflow more efficient.

## Features

### Nautilus Extensions

- **Copy Location**: Copy file or folder paths to the clipboard.
- **Merge CSV**: Combine multiple CSV files into a single file.
- **Merge PDF**: Merge PDF files using `pdfunite`.
- **Merge DOC**: Merge DOC/DOCX files using `pandoc`.
- **Merge PPT**: Merge PPT/PPTX files via PDF conversion with `unoconv`.
- **Flatten Folder**: Move all files from subdirectories to the root folder.
- **Organize by Extension**: Sort files into subdirectories based on their lowercase extensions.

### KamayPWA

- **Make your own PWAs**: The app launches a terminal shell asking for the desired URL.
- **Works with either Chrome or Edge**: The script prompts for the desired browser to make the PWA from.
- **Name Prompt**: Inquires the user to provide a name.
- **Custom logo**: You can choose your own icon in this prompt by providing the full path to an image.
- **Sandboxed PWAs**: No PWA stores cookies sessions from one another.
- **Option to edit existing PWAs**: You can edit existing PWAs from the main interface menu.
- **List all PWAs**: Optiion from the main menu that lists all PWAs installed.
- **Delete a PWA**: Option from the main menu to remove an existing PWA.

## Prerequisites

Before installing, ensure you have the following dependencies installed on your Linux system (Ubuntu/Debian-based):

```bash
sudo apt update
sudo apt install -y python3-nautilus python3-gi libnotify-bin pdfunite pandoc unoconv kitty
```

- `python3-nautilus`: Enables Nautilus Python extensions.
- `python3-gi`: Provides `PyGObject` for Nautilus integration.
- `libnotify-bin`: Supports desktop notifications.
- `pdfunite`: Required for `merge_pdf`.
- `pandoc`: Required for `merge_doc`.
- `unoconv`: Required for `merge_ppt`.
- `kitty`: Required for `KamayPWA`

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

2. **Run the setup scripts**

   - For **nautilus-extensions:**

   ```bash
   /apps/nautilus-extensions/setup.sh
   ```

   - For **KamayPWA:**

      ```bash
      /apps/web/KamayPWA/setup.sh
      ```

## Testing

1. Open Nautilus (Files) in your Linux desktop environment.
2. Right-click on a file or folder:
   - Select **Copy Location** to copy the path to the clipboard.
   - The context menu should dynamically fetch the appropriate script when selecting files or folders (e.g., `merge_csv.sh`, `flatten_folder.sh`, `merge_pdf.sh`).
3. For file merging (e.g., CSV, PDF, DOC, PPT), select multiple files, right-click, and choose the corresponding script from the menu.
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
