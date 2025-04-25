#!/bin/bash

while true; do
  echo "Welcome to pwaCRAFTER"
  echo
  echo "1) Create a new WebApp"
  echo "2) Edit an existing WebApp"
  echo "3) Remove an existing WebApp"
  echo "4) List all WebApps"
  echo "5) Exit"
  echo

  read -r -p "Select an option: " MENU_OPTION

  while [[ ! "$MENU_OPTION" =~ ^[1-5]$ ]]; do
    echo "Invalid option. Please select a number between 1 and 5."
    read -r -p "Select an option: " MENU_OPTION
  done

  case "$MENU_OPTION" in
    1)
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
        continue
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
      ;;
    2)
      # Edit an existing WebApp
      APPS_DIR="$HOME/.local/share/applications"
      mapfile -t WEBAPPS < <(find "$APPS_DIR" -maxdepth 1 -type f -name '*.desktop' -printf '%f\n')
      if [ ${#WEBAPPS[@]} -eq 0 ]; then
        echo "No WebApps found to edit."
        continue
      fi
      echo "Available WebApps:"
      select APP_FILE in "${WEBAPPS[@]}"; do
        if [ -n "$APP_FILE" ]; then
          DESKTOP_FILE="$APPS_DIR/$APP_FILE"
          break
        else
          echo "Invalid selection."
        fi
      done
      echo "Editing $DESKTOP_FILE"
      ${EDITOR:-nano} "$DESKTOP_FILE"
      echo "Done editing."
      ;;
    3)
      # Remove an existing WebApp
      APPS_DIR="$HOME/.local/share/applications"
      mapfile -t WEBAPPS < <(find "$APPS_DIR" -maxdepth 1 -type f -name '*.desktop' -printf '%f\n')
      if [ ${#WEBAPPS[@]} -eq 0 ]; then
        echo "No WebApps found to remove."
        continue
      fi
      echo "Available WebApps:"
      select APP_FILE in "${WEBAPPS[@]}"; do
        if [ -n "$APP_FILE" ]; then
          DESKTOP_FILE="$APPS_DIR/$APP_FILE"
          # Try to extract profile dir from Exec line
          PROFILE_DIR=$(grep '^Exec=' "$DESKTOP_FILE" | sed -n 's/.*--user-data-dir=\([^ ]*\).*/\1/p')
          rm -f "$DESKTOP_FILE"
          if [ -n "$PROFILE_DIR" ] && [ -d "$PROFILE_DIR" ]; then
            rm -rf "$PROFILE_DIR"
          fi
          echo "Removed $APP_FILE and its profile directory."
          break
        else
          echo "Invalid selection."
        fi
      done
      ;;
    4)
      # List all WebApps
      APPS_DIR="$HOME/.local/share/applications"
      mapfile -t WEBAPPS < <(find "$APPS_DIR" -maxdepth 1 -type f -name '*.desktop' -printf '%f\n')
      if [ ${#WEBAPPS[@]} -eq 0 ]; then
        echo "No WebApps found."
        continue
      fi
      echo "Available WebApps:"
      for APP_FILE in "${WEBAPPS[@]}"; do
        # Extract the app name from the .desktop file
        APP_NAME=$(grep '^Name=' "$APPS_DIR/$APP_FILE" | cut -d'=' -f2)
        echo "- $APP_NAME"
      done
      echo
      echo "To remove a WebApp, select option 3 from the main menu."
      echo "To edit a WebApp, select option 2 from the main menu."
      echo "To create a new WebApp, select option 1 from the main menu."
      echo "To exit, select option 5 from the main menu."
      echo
      ;;
    5)
      echo "Exiting pwaCRAFTER. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid option."
      ;;
  esac

  echo
  read -n 1 -s -r -p "Press any key to return to the main menu..."
  echo
done

