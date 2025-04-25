#!/bin/bash

# Prompt user for required information
read -r -p "Enter the URL of the web app: " URL
read -r -p "Enter the browser (edge/chrome): " BROWSER
read -r -p "Enter a name for your app (e.g., Copilot): " APP_NAME
read -r -p "Enter the full path to the icon (e.g., /path/to/icon.png): " ICON_PATH

# Normalize browser input to lowercase
BROWSER=$(echo "$BROWSER" | tr '[:upper:]' '[:lower:]')

# Set browser binary path based on user input
case "$BROWSER" in
edge)
  BROWSER_PATH="/opt/microsoft/msedge/microsoft-edge" # Path for Microsoft Edge
  ;;
chrome)
  BROWSER_PATH="/usr/bin/google-chrome" # Path for Google Chrome
  ;;
*)
  echo "Unsupported browser: $BROWSER"
  exit 1
  ;;
esac

# Create a unique profile directory for the web app
PROFILE_DIR="$HOME/.local/share/webapps/${APP_NAME// /_}"
mkdir -p "$PROFILE_DIR"

# Create a unique WM class for the PWA (used by window managers)
WM_CLASS="WebApp-${APP_NAME// /_}"

# Create .desktop file for launching the PWA from the application menu
DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME// /_}.desktop"
cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=$BROWSER_PATH --user-data-dir=$PROFILE_DIR --app=$URL --class=$WM_CLASS
Icon=$ICON_PATH
Terminal=false
StartupWMClass=$WM_CLASS
EOF

# Make the .desktop file executable
chmod +x "$DESKTOP_FILE"

# Print success message and instructions for launching/removing the app
echo "✅ Web app '$APP_NAME' created and can be launched from your application menu."
echo "You can also run it from the terminal using:"
echo "$BROWSER_PATH --user-data-dir=$PROFILE_DIR --app=$URL --class=$WM_CLASS"
echo "To remove the app, delete the .desktop file and the profile directory:"
echo "rm -rf $PROFILE_DIR"
echo "rm $DESKTOP_FILE"
