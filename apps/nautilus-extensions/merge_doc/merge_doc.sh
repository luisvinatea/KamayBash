#!/bin/bash
# Usage: ./merge_doc.sh --files <file1> <file2> ...
# Dependencies: pandoc, libnotify-bin

# Check if pandoc is installed
if ! command -v pandoc &>/dev/null; then
  notify-send -u critical "Error" "pandoc not found. Install it with 'sudo apt install pandoc'."
  exit 1
fi

# Check if libnotify-bin is installed for notifications
if ! command -v notify-send &>/dev/null; then
  echo "libnotify-bin not found. Install it with 'sudo apt install libnotify-bin' for notifications."
fi

# Function to merge DOC/DOCX files
merge_doc_files() {
  local output_file="$1"
  shift
  local doc_files=("$@")
  
  if [ ${#doc_files[@]} -lt 1 ]; then
    notify-send -u critical "Error" "No DOC/DOCX files provided."
    exit 1
  fi

  # Verify all files exist and are readable
  for file in "${doc_files[@]}"; do
    if [ ! -r "$file" ]; then
      notify-send -u critical "Error" "File $file is not readable or does not exist."
      exit 1
    fi
  done

  # Temporary directory for intermediate files
  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' EXIT

  # Convert each file to DOCX and merge
  local input_files=()
  for file in "${doc_files[@]}"; do
    local temp_output
    temp_output="$temp_dir/$(basename "$file").docx"
    if pandoc "$file" -o "$temp_output" --to=docx; then
      input_files+=("$temp_output")
    else
      notify-send -u critical "Error" "Failed to convert $file to DOCX."
      rm -rf "$temp_dir"
      exit 1
    fi
  done

  # Merge all files into the output
  if pandoc "${input_files[@]}" -o "$output_file" --to=docx; then
    notify-send "Success" "DOC files merged into $output_file."
  else
    notify-send -u critical "Error" "Failed to merge DOC files."
    rm -rf "$temp_dir"
    exit 1
  fi
}

# Parse arguments
case "$1" in
  --files)
    shift
    if [ $# -lt 1 ]; then
      notify-send -u critical "Error" "At least one DOC/DOCX file is required."
      exit 1
    fi
    output_dir=$(dirname "$1")
    output_file="$output_dir/merged.docx"
    merge_doc_files "$output_file" "$@"
    ;;
  *)
    notify-send -u critical "Error" "Invalid usage. Use --files <file1> <file2> ..."
    exit 1
    ;;
esac