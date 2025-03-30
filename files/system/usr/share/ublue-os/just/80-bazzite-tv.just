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
