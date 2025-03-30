# Connect home using WireGuard
connect-home:
    #!/bin/bash
    echo "Connecting to home"
    sudo tailscale up --exit-node fw --accept-routes

# Disconnect from home using WireGuard
disconnect-home:
    #!/bin/bash
    echo "Disconnecting from home"
    tailscale down

# setup the rest of bazzite tv that cant be done in github
setup-bazzite-tv:
    #!/bin/bash
    echo "Creating Distroboxes"
    distrobox-assemble create --file https://raw.githubusercontent.com/dillydilly1990/bazzite-tv/refs/heads/main/files/disrobox/distrobox.ini
####   Install and configure Decky Loader (https://github.com/SteamDeckHomebrew/decky-loader) and plugins for alternative handhelds
####
    echo "Setting up Decky Loader"  
setup-decky ACTION="install":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    DECKY_STATE="${b}${red}Not Installed${n}"
    if [[ -d $HOME/homebrew/plugins ]]; then
      DECKY_STATE="${b}${green}Installed${n}"
    fi
    OPTION={{ ACTION }}
    if [ "$OPTION" == "help" ]; then
      echo "Usage: ujust setup-decky <option>"
      echo "  <option>: Specify the quick option to skip the prompt"
      echo "  Use 'install' to select Install Decky"
      echo "  Use 'prerelease' to select Install Decky Prerelease"
      exit 0
    fi
    if [[ "${OPTION,,}" =~ install ]]; then
      export HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)
      if [ ! -L "/home/deck" ] && [ ! -e "/home/deck" ]  && [ "$HOME" != "/home/deck" ]; then
        echo "Making a /home/deck symlink to fix plugins that do not use environment variables."
        sudo ln -sf "$HOME" /home/deck
      fi
      curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
      sudo chcon -R -t bin_t $HOME/homebrew/services/PluginLoader
    fi
    if [[ "${OPTION,,}" =~ prerelease ]]; then
      export HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)
      if [ ! -L "/home/deck" ] && [ ! -e "/home/deck" ]  && [ "$HOME" != "/home/deck" ]; then
        echo "Making a /home/deck symlink to fix plugins that do not use environment variables."
        sudo ln -sf "$HOME" /home/deck
      fi
      curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_prerelease.sh | sh
      sudo chcon -R -t bin_t $HOME/homebrew/services/PluginLoader
    fi
####  Decky Plugin Bazzite bazzite-buddy
      echo "Install Bazzite Buddy"
    #!/bin/bash
    PLUGIN_URL="https://github.com/xXJSONDeruloXx/bazzite-buddy/releases/download/stable/bazzite-buddy.zip"
    PLUGIN_NAME="bazzite-buddy"
    PLUGIN_DIR="$HOME/homebrew/plugins"
    if [ ! -d "$PLUGIN_DIR" ]; then
      echo "Creating plugins directory with sudo..."
      sudo mkdir -p "$PLUGIN_DIR"
    fi
    # Change to the plugin directory
    cd "$PLUGIN_DIR" || { echo "Failed to navigate to plugins directory"; exit 1; }
    # Remove any existing plugin folder
    if [ -d "$PLUGIN_NAME" ]; then
      echo "Removing existing $PLUGIN_NAME directory with sudo..."
      sudo rm -rf "$PLUGIN_NAME"
    fi
    # Download the zip file
    echo "Downloading $PLUGIN_NAME from $PLUGIN_URL..."
    sudo curl -L -o "${PLUGIN_NAME}.zip" "$PLUGIN_URL"
    if [ $? -ne 0 ]; then
      echo "Download failed!"
      exit 1
    fi
    echo "Extracting $PLUGIN_NAME..."
    sudo unzip -o "${PLUGIN_NAME}.zip" -d .
    if [ $? -ne 0 ]; then
      echo "Extraction failed!"
      exit 1
    fi
    # Move the extracted files to the correct location if nested
    if [ -d "./${PLUGIN_NAME}/${PLUGIN_NAME}" ]; then
      echo "Fixing folder structure..."
      sudo mv ./${PLUGIN_NAME}/${PLUGIN_NAME}/* ./${PLUGIN_NAME}/
      sudo rm -rf ./${PLUGIN_NAME}/${PLUGIN_NAME}
    fi
    # Clean up the downloaded ZIP file
    echo "Cleaning up..."
    sudo rm -f "${PLUGIN_NAME}.zip"
    # Confirm installation
    echo "$PLUGIN_NAME has been installed successfully to $PLUGIN_DIR!"
    # Prompt user to restart Decky Loader
    echo "Please restart Decky Loader to activate the plugin."
