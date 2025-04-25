#!/bin/bash
# Usage: ./merge_ppt.sh --files <file1> <file2> ...
# Dependencies: unoconv, poppler-utils, libnotify-bin, libreoffice

# Check if unoconv is installed
if ! command -v unoconv &>/dev/null; then
  notify-send -u critical "Error" "unoconv not found. Install it with 'sudo apt install unoconv'."
  exit 1
fi

# Check if pdfunite is installed
if ! command -v pdfunite &>/dev/null; then
  notify-send -u critical "Error" "pdfunite not found. Install it with 'sudo apt install poppler-utils'."
  exit 1
fi

# Check if libreoffice is installed
if ! command -v libreoffice &>/dev/null; then
  notify-send -u critical "Error" "libreoffice not found. Install it with 'sudo apt install libreoffice'."
  exit 1
fi

# Check if libnotify-bin is installed for notifications
if ! command -v notify-send &>/dev/null; then
  echo "libnotify-bin not found. Install it with 'sudo apt install libnotify-bin' for notifications."
fi

# Function to merge PPT/PPTX files
merge_ppt_files() {
  local output_file="$1"
  shift
  local ppt_files=("$@")
  
  if [ ${#ppt_files[@]} -lt 1 ]; then
    notify-send -u critical "Error" "No PPT/PPTX files provided."
    exit 1
  fi

  # Verify all files exist and are readable
  for file in "${ppt_files[@]}"; do
    if [ ! -r "$file" ]; then
      notify-send -u critical "Error" "File $file is not readable or does not exist."
      exit 1
    fi
  done

  # Temporary directory for intermediate files
  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' EXIT

  # Convert each PPT/PPTX to PDF
  local pdf_files=()
  for file in "${ppt_files[@]}"; do
    local temp_pdf
    temp_pdf="$temp_dir/$(basename "$file").pdf"
    if unoconv -f pdf -o "$temp_pdf" "$file"; then
      pdf_files+=("$temp_pdf")
    else
      notify-send -u critical "Error" "Failed to convert $file to PDF."
      rm -rf "$temp_dir"
      exit 1
    fi
  done

  # Merge PDFs
  local merged_pdf="$temp_dir/merged.pdf"
  if pdfunite "${pdf_files[@]}" "$merged_pdf"; then
    # Convert merged PDF back to PPTX
    if unoconv -f pptx -o "$output_file" "$merged_pdf"; then
      notify-send "Success" "PPT files merged into $output_file."
    else
      notify-send -u critical "Error" "Failed to convert merged PDF to PPTX."
      rm -rf "$temp_dir"
      exit 1
    fi
  else
    notify-send -u critical "Error" "Failed to merge PDFs."
    rm -rf "$temp_dir"
    exit 1
  fi
}

# Parse arguments
case "$1" in
  --files)
    shift
    if [ $# -lt 1 ]; then
      notify-send -u critical "Error" "At least one PPT/PPTX file is required."
      exit 1
    fi
    output_dir=$(dirname "$1")
    output_file="$output_dir/merged.pptx"
    merge_ppt_files "$output_file" "$@"
    ;;
  *)
    notify-send -u critical "Error" "Invalid usage. Use --files <file1> <file2> ..."
    exit 1
    ;;
esac