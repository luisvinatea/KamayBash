#!/bin/bash
# Usage: ./organize_by_extension.sh --dir <directory>
# Dependencies: libnotify-bin

# Check if libnotify-bin is installed for notifications
if ! command -v notify-send &>/dev/null; then
  echo "libnotify-bin not found. Install it with 'sudo apt install libnotify-bin' for notifications."
fi

# Function to generate a unique filename to avoid conflicts
get_unique_filename() {
  local dest_file="$1"
  local base_name
  base_name=$(basename "$dest_file")
  local dir_name
  dir_name=$(dirname "$dest_file")
  local name="${base_name%.*}"
  local ext="${base_name##*.}"
  local counter=1

  # If no extension, treat the whole name as the base
  if [ "$name" = "$ext" ]; then
    ext=""
  else
    ext=".$ext"
  fi

  # Check if file exists and generate a new name
  while [ -e "$dir_name/$name$ext" ]; do
    name="${base_name%.*}_$counter"
    counter=$((counter + 1))
  done

  echo "$dir_name/$name$ext"
}

# Function to organize files by extension
organize_by_extension() {
  local dir="$1"

  # Verify directory exists and is writable
  if [ ! -d "$dir" ]; then
    notify-send -u critical "Error" "Directory $dir does not exist."
    exit 1
  fi
  if [ ! -w "$dir" ]; then
    notify-send -u critical "Error" "Directory $dir is not writable."
    exit 1
  fi

  # Find all files in the root directory (not subdirectories)
  find "$dir" -maxdepth 1 -type f | while IFS= read -r file; do
    # Get the file's extension (lowercase)
    base_name=$(basename "$file")
    ext="${base_name##*.}"
    if [ "$base_name" = "$ext" ]; then
      # No extension
      ext_dir="no_extension"
    else
      # Convert extension to lowercase
      ext_dir=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    fi

    # Create the extension directory if it doesn't exist
    mkdir -p "$dir/$ext_dir"

    # Get the destination path
    dest_file="$dir/$ext_dir/$base_name"

    # Handle naming conflicts
    if [ -e "$dest_file" ]; then
      dest_file=$(get_unique_filename "$dest_file")
    fi

    # Move the file to the extension directory
    if mv "$file" "$dest_file"; then
      echo "Moved $file to $dest_file"
    else
      notify-send -u critical "Error" "Failed to move $file."
      exit 1
    fi
  done

  # Check if any files were processed
  if [ -z "$(find "$dir" -maxdepth 1 -type f)" ]; then
    notify-send "Info" "No files found in $dir to organize."
  else
    notify-send "Success" "Files in $dir organized by extension."
  fi
}

# Parse arguments
case "$1" in
  --dir)
    shift
    if [ $# -ne 1 ]; then
      notify-send -u critical "Error" "Exactly one directory must be provided."
      exit 1
    fi
    organize_by_extension "$1"
    ;;
  *)
    notify-send -u critical "Error" "Invalid usage. Use --dir <directory>"
    exit 1
    ;;
esac