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
#    BAZZITE-TV_FLATPAK_LIST="$(curl https://github.com/dillydilly1990/bazzite-tv/blob/main/files/flatpaks/bazzite-tv_flatpaks | tr '\n' ' ')"
#    echo "Installing bazzite-tv Flatpaks.."
#    flatpak --system -y install ${BAZZITE-TV_FLATPAK_LIST}
    distrobox-assemble create --file https://raw.githubusercontent.com/dillydilly1990/bazzite-tv/refs/heads/main/files/disrobox/distrobox.ini
