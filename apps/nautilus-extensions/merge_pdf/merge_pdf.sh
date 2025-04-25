#!/bin/bash
# Usage: ./merge_pdf.sh --files <file1> <file2> ...
# Dependencies: poppler-utils, libnotify-bin

# Check if pdfunite is installed
if ! command -v pdfunite &>/dev/null; then
  notify-send -u critical "Error" "pdfunite not found. Install it with 'sudo apt install poppler-utils'."
  exit 1
fi

# Check if libnotify-bin is installed for notifications
if ! command -v notify-send &>/dev/null; then
  echo "libnotify-bin not found. Install it with 'sudo apt install libnotify-bin' for notifications."
fi

# Function to merge PDF files
merge_pdf_files() {
  local output_file="$1"
  shift
  local pdf_files=("$@")
  
  if [ ${#pdf_files[@]} -lt 1 ]; then
    notify-send -u critical "Error" "No PDF files provided."
    exit 1
  fi

  # Verify all files exist and are readable
  for file in "${pdf_files[@]}"; do
    if [ ! -r "$file" ]; then
      notify-send -u critical "Error" "File $file is not readable or does not exist."
      exit 1
    fi
  done

  # Merge PDF files using pdfunite
  if pdfunite "${pdf_files[@]}" "$output_file"; then
    notify-send "Success" "PDF files merged into $output_file."
  else
    notify-send -u critical "Error" "Failed to merge PDF files."
    exit 1
  fi
}

# Parse arguments
case "$1" in
  --files)
    shift
    if [ $# -lt 1 ]; then
      notify-send -u critical "Error" "At least one PDF file is required."
      exit 1
    fi
    output_dir=$(dirname "$1")
    output_file="$output_dir/merged.pdf"
    merge_pdf_files "$output_file" "$@"
    ;;
  *)
    notify-send -u critical "Error" "Invalid usage. Use --files <file1> <file2> ..."
    exit 1
    ;;
esac