#!/bin/bash

# Get the absolute path of the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
APP_DIR="$SCRIPT_DIR"
LIB_DIR="$APP_DIR/lib"
ASSETS_DIR="$APP_DIR/assets"
APP_SCRIPT="$LIB_DIR/KamayPWA.sh"
ICON_SOURCE="$ASSETS_DIR/static/icons/KamayPWA.png"

# --- Configuration ---
APP_NAME="KamayPWA"
ICON_DEST_DIR="$HOME/.local/share/icons"
ICON_DEST_NAME="${APP_NAME}.png"
ICON_DEST_PATH="$ICON_DEST_DIR/$ICON_DEST_NAME"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE_NAME="${APP_NAME}.desktop"
DESKTOP_FILE_PATH="$DESKTOP_DIR/$DESKTOP_FILE_NAME"
WM_CLASS="KamayPWA" # Window Manager Class

# --- Dependency Check ---
if ! command -v kitty &>/dev/null; then
  echo "Error: 'kitty' terminal emulator is required but not found."
  echo "Please install kitty (e.g., 'sudo apt install kitty' or check your package manager)."
  exit 1
fi

# --- Installation ---
echo "Starting KamayPWA setup..."

# Create necessary directories if they don't exist
mkdir -p "$ICON_DEST_DIR"
mkdir -p "$DESKTOP_DIR"
echo "Directories ensured."

# Copy the icon
if [ -f "$ICON_SOURCE" ]; then
  cp "$ICON_SOURCE" "$ICON_DEST_PATH"
  echo "Icon copied to $ICON_DEST_PATH"
else
  echo "Warning: Icon file not found at $ICON_SOURCE. Skipping icon installation."
  # Set a default icon path or leave it empty if preferred
  ICON_DEST_PATH="" # Or provide a path to a default system icon
fi

# Check if the main script exists
if [ ! -f "$APP_SCRIPT" ]; then
  echo "Error: Main application script not found at $APP_SCRIPT"
  exit 1
fi

# Create the .desktop file
echo "Creating desktop entry at $DESKTOP_FILE_PATH..."
cat >"$DESKTOP_FILE_PATH" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=kitty --class $WM_CLASS -- bash -c "$APP_SCRIPT; exec bash"
Icon=$ICON_DEST_PATH
Terminal=false
StartupWMClass=$WM_CLASS
Comment=Manage Progressive Web Apps
Categories=Utility;Application;
EOF

# Make the .desktop file executable (optional but good practice)
chmod +x "$DESKTOP_FILE_PATH"

echo "Desktop entry created."
echo "✅ KamayPWA setup complete. You should find '$APP_NAME' in your application menu."
echo "   If it doesn't appear immediately, you might need to log out and log back in."

exit 0
