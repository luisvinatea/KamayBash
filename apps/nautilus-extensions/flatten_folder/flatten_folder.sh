#!/bin/bash
# Usage: ./flatten_folder.sh --dir <directory>
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

# Function to flatten the directory
flatten_directory() {
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

  # Find all files in subdirectories (excluding the root directory itself)
  find "$dir" -type f -mindepth 2 | while IFS= read -r file; do
    # Get the destination path (root of the directory)
    dest_file="$dir/$(basename "$file")"

    # Handle naming conflicts
    if [ -e "$dest_file" ]; then
      dest_file=$(get_unique_filename "$dest_file")
    fi

    # Move the file to the root directory
    if mv "$file" "$dest_file"; then
      echo "Moved $file to $dest_file"
    else
      notify-send -u critical "Error" "Failed to move $file."
      exit 1
    fi
  done

  # Remove empty directories
  find "$dir" -type d -mindepth 1 -empty -delete

  # Check if any directories remain (non-empty)
  if find "$dir" -type d -mindepth 1 | grep -q .; then
    notify-send "Warning" "Some non-empty subdirectories remain in $dir."
  else
    notify-send "Success" "Folder $dir has been flattened."
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
    flatten_directory "$1"
    ;;
  *)
    notify-send -u critical "Error" "Invalid usage. Use --dir <directory>"
    exit 1
    ;;
esac