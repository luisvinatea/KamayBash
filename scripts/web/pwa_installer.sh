#!/bin/bash

# Prompt user
read  -r -p "Enter the URL of the web app: " URL
read  -r -p "Enter the browser (edge/chrome): " BROWSER
read -r -p "Enter a name for your app (e.g., Copilot): " APP_NAME
read -r -p "Enter the full path to the icon (e.g., /path/to/icon.png): " ICON_PATH

# Normalize browser input
BROWSER=$(echo "$BROWSER" | tr '[:upper:]' '[:lower:]')

# Set browser binary path
case "$BROWSER" in
  edge)
    BROWSER_PATH="/opt/microsoft/msedge/microsoft-edge"
    WM_CLASS="Microsoft-edge"
    ;;
  chrome)
    BROWSER_PATH="/usr/bin/google-chrome"
    WM_CLASS="Google-chrome"
    ;;
  *)
    echo "Unsupported browser: $BROWSER"
    exit 1
    ;;
esac

# Create a unique profile directory
PROFILE_DIR="$HOME/.local/share/webapps/${APP_NAME// /_}"
mkdir -p "$PROFILE_DIR"

# Create .desktop file
DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME// /_}.desktop"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Exec=$BROWSER_PATH --user-data-dir=$PROFILE_DIR --app=$URL
Icon=$ICON_PATH
Terminal=false
StartupWMClass=$WM_CLASS
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ Web app '$APP_NAME' created and can be launched from your application menu."
echo "You can also run it from the terminal using:"
echo "$BROWSER_PATH --user-data-dir=$PROFILE_DIR --app=$URL"
echo "To remove the app, delete the .desktop file and the profile directory:"
echo "rm -rf $PROFILE_DIR"
echo "rm $DESKTOP_FILE"