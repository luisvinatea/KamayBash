#!/bin/bash
# Usage: ./merge_csv.sh [--dir <directory> | --files <file1> <file2> ...]
# Dependencies: csvkit, libnotify-bin

# Check if csvkit is installed
if ! command -v csvstack &>/dev/null; then
  notify-send -u critical "Error" "csvkit not found. Install it with 'pip install csvkit'."
  exit 1
fi

# Check if libnotify-bin is installed for notifications
if ! command -v notify-send &>/dev/null; then
  echo "libnotify-bin not found. Install it with 'sudo apt install libnotify-bin' for notifications."
fi

# Function to merge CSV files
merge_csv_files() {
  local output_file="$1"
  shift
  local csv_files=("$@")
  
  if [ ${#csv_files[@]} -lt 1 ]; then
    notify-send -u critical "Error" "No CSV files found."
    exit 1
  fi

  # Verify all files exist and are readable
  for file in "${csv_files[@]}"; do
    if [ ! -r "$file" ]; then
      notify-send -u critical "Error" "File $file is not readable or does not exist."
      exit 1
    fi
  done

  # Merge CSV files using csvstack
  if csvstack "${csv_files[@]}" > "$output_file"; then
    notify-send "Success" "CSV files merged into $output_file."
  else
    notify-send -u critical "Error" "Failed to merge CSV files."
    exit 1
  fi
}

# Parse arguments
case "$1" in
  --dir)
    if [ -z "$2" ]; then
      notify-send -u critical "Error" "No directory specified."
      exit 1
    fi
    dir="$2"
    if [ ! -d "$dir" ]; then
      notify-send -u critical "Error" "Directory $dir does not exist."
      exit 1
    fi
    csv_files=("$dir"/*.csv)
    if [ ! -e "${csv_files[0]}" ]; then
      notify-send -u critical "Error" "No CSV files found in $dir."
      exit 1
    fi
    output_file="$dir/merged.csv"
    merge_csv_files "$output_file" "${csv_files[@]}"
    ;;
  --files)
    shift
    if [ $# -lt 2 ]; then
      notify-send -u critical "Error" "At least two CSV files are required."
      exit 1
    fi
    output_dir=$(dirname "$1")
    output_file="$output_dir/merged.csv"
    merge_csv_files "$output_file" "$@"
    ;;
  *)
    notify-send -u critical "Error" "Invalid usage. Use --dir <directory> or --files <file1> <file2> ..."
    exit 1
    ;;
esac