# Contributing to KamayBash

Thank you for your interest in contributing to **KamayBash**, a collection of Bash and Python scripts for automating file management tasks in Linux via Nautilus extensions. We welcome contributions to improve the project, whether through bug fixes, new features, documentation enhancements, or testing. This guide outlines how to contribute effectively.

## Code of Conduct

By participating, you agree to treat everyone with respect and follow a collaborative, inclusive approach. Be kind and constructive in all interactions.

## How to Contribute

### Reporting Issues

If you encounter bugs, unexpected behavior, or have feature requests:
1. Check the [Issues](https://github.com/<username>/KamayBash/issues) page to avoid duplicates.
2. Open a new issue with:
   - A clear title (e.g., "merge_pdf.py fails with large PDF files").
   - A detailed description, including:
     - Steps to reproduce (e.g., "Select three PDFs, right-click, choose Scripts > merge_pdf.sh").
     - Expected vs. actual behavior.
     - Environment details (e.g., Ubuntu version, Nautilus version, Python version).
     - Relevant logs or screenshots.
3. Use appropriate labels (e.g., `bug`, `enhancement`).

### Submitting Pull Requests

To contribute code or documentation:
1. **Fork the Repository**:
   ```bash
   git clone https://github.com/<username>/KamayBash.git
   cd KamayBash
   ```
2. **Create a Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
   Use descriptive branch names (e.g., `fix/merge-csv-error`, `docs/add-usage-guide`).
3. **Make Changes**:
   - Place Python scripts in `apps/nautilus-extensions/<function>/` (e.g., `apps/nautilus-extensions/merge_csv/merge_csv.py`).
   - Place Bash scripts in the same subdirectory (e.g., `apps/nautilus-extensions/merge_csv/merge_csv.sh`).
   - Update documentation in `docs/` (e.g., `docs/extensions/merge_csv.rst`).
   - Follow coding standards (see below).
4. **Test Your Changes**:
   - Install dependencies:
     ```bash
     sudo apt install -y python3-nautilus python3-gi libnotify-bin pdfunite pandoc unoconv
     pip install PyGObject
     ```
   - Copy scripts to Nautilus directories:
     ```bash
     cp apps/nautilus-extensions/*/*.py ~/.local/share/nautilus-python/extensions/
     cp apps/nautilus-extensions/*/*.sh ~/.local/share/nautilus/scripts/
     chmod +x ~/.local/share/nautilus/scripts/*.sh
     nautilus -q
     ```
   - Test in Nautilus (e.g., right-click files, verify context menu options).
   - Build documentation:
     ```bash
     cd docs
     pip install sphinx sphinx-rtd-theme
     make html
     ```
5. **Commit Changes**:
   - Use clear commit messages (e.g., "Add merge_csv.py error handling").
   - Include updates to `README.md` or `docs/` if relevant.
   ```bash
   git add .
   git commit -m "Your descriptive commit message"
   ```
6. **Push and Create a Pull Request**:
   ```bash
   git push origin feature/your-feature-name
   ```
   - Open a pull request (PR) on GitHub.
   - Describe the changes, referencing any related issues (e.g., "Fixes #123").
   - Ensure tests pass in the GitHub Actions CI/CD pipeline.

### Coding Standards

- **Python**:
  - Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/) for style.
  - Use descriptive variable/function names (e.g., `merge_pdf_files`).
  - Include docstrings for modules, classes, and functions (Google style, as `sphinx.ext.napoleon` is used).
  - Example:
    ```python
    def merge_pdf_files(files, output):
        """Merge multiple PDF files into a single file.

        Args:
            files (list): List of PDF file paths.
            output (str): Path for the merged PDF.

        Returns:
            bool: True if successful, False otherwise.
        """
    ```

- **Bash**:
  - Use `#!/bin/bash` shebang.
  - Follow [ShellCheck](https://www.shellcheck.net/) guidelines (`.shellcheckrc` is included).
  - Include comments for complex logic.
  - Example:
    ```bash
    #!/bin/bash
    # Merge CSV files into a single file
    output="merged.csv"
    cat "$@" > "$output"
    notify-send "CSV Merge" "Merged into $output"
    ```

- **Documentation**:
  - Update `docs/extensions/*.rst` for new or modified Python modules.
  - Use reStructuredText (RST) for Sphinx compatibility.
  - Example:
    ```rst
    merge_csv
    =========

    .. automodule:: merge_csv
       :members:
       :undoc-members:
       :show-inheritance:
    ```

- **File Structure**:
  - Place scripts in `apps/nautilus-extensions/<function>/` (e.g., `merge_csv/merge_csv.py`, `merge_csv/merge_csv.sh`).
  - Update `docs/conf.py` if new module paths are added.

### Testing

- Test extensions in Nautilus:
  - Right-click files/folders to verify context menu options (e.g., “Copy Location”, “Scripts > merge_pdf.sh”).
  - Check desktop notifications (via `libnotify-bin`).
- Validate documentation builds:
  ```bash
  cd docs
  make html
  xdg-open _build/html/index.html
  ```
- Ensure no errors in Python (`PyGObject`) or Bash scripts (`shellcheck`).

### Getting Help

- Check the [Documentation](https://<username>.github.io/KamayBash/) for detailed usage and API references.
- Ask questions via [Issues](https://github.com/<username>/KamayBash/issues) or join discussions on GitHub.

Thank you for contributing to KamayBash! Your efforts help make file management in Linux more efficient.