#!/bin/bash
# This script prompts the user for a directory containing CSV files and joins them into a single CSV file.
# The user can navigate through the directory structure using a keyboard-navigable shell interface.
# The script uses the `csvstack` command to join the CSV files.
# The script also provides an option to specify a custom output file name.
# The script requires the `csvkit` package to be installed.
# Usage: ./join_csv.sh
# Dependencies: csvkit

# Check if csvkit is installed
if ! command -v csvstack &>/dev/null; then
  echo "csvkit could not be found. Please install it using 'pip install csvkit'."
  exit 1
fi

# Function to join CSV files in the selected directory
function join_csv_files() {
  local dir="$1"
  local output_file="$2"
  local csv_files=("$dir"/*.csv)
  if [ ${#csv_files[@]} -eq 0 ]; then
    echo "No CSV files found in $dir."
    return
  fi
  echo "Joining CSV files in $dir..."
  csvstack "${csv_files[@]}" >"$output_file"
  echo "CSV files joined into $output_file."
}

# Function to render a keyboard-navigable shell interface for directory selection
function select_directory() {
  local current_dir="$1"
  while true; do
# Display the current directory and its contents
    echo "Current directory: $current_dir"
    echo "Contents:"
    ls -1 "$current_dir"
    output_file=${output_file:-joined.csv}
    dirs=()
    if [ "$current_dir" != "/" ]; then
      dirs+=(".. (go up)")
    fi
    for entry in "$current_dir"/*; do
      [ -d "$entry" ] && dirs+=("$(basename "$entry")")
    done
    dirs+=("Select this directory")
    PS3="Use number keys to navigate. Enter your choice: "
    select opt in "${dirs[@]}"; do
      if [[ "$opt" == "Select this directory" ]]; then
        echo "$current_dir"
        echo "Contents of $current_dir:"
        ls -1 "$current_dir"
        echo "Selected directory: $current_dir"
        echo "Output file: $output_file"
        echo "Joining CSV files in $current_dir..."
        csvstack "$current_dir"/*.csv >"$output_file"
        echo "CSV files joined into $output_file."
        return 0
      elif [[ "$opt" == ".. (go up)" ]]; then
        current_dir="$(dirname "$current_dir")"
        break
      elif [[ -n "$opt" ]]; then
        current_dir="$current_dir/$opt"
        break
      else
        echo "Invalid choice."
      fi
    done
  done
}

# Main script
echo "Please enter the base directory containing CSV files: "
read -r base_dir
if [ ! -d "$base_dir" ]; then
  echo "The provided base directory does not exist."
  exit 1
fi

# Directory navigation interface
selected_dir=$(select_directory "$base_dir")
if [ -z "$selected_dir" ]; then
  echo "No directory selected. Exiting."
  exit 1
fi

# Prompt for output file name
read -r -p "Enter output file name (default: joined.csv): " output_file
output_file=${output_file:-joined.csv}
# Join CSV files in the selected directory
join_csv_files "$selected_dir" "$output_file"

# End of script
# This script is designed to be run in a shell environment.

