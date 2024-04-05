#!/bin/bash

# Define PulseAudio related variables
PULSE_DIR="/home/kodifly/pulseaudio"
PULSE_SOCKET="$PULSE_DIR/pulseaudio.socket"
PULSE_CONF="$PULSE_DIR/pulseaudio.client.conf"

# Check if PulseAudio module is already loaded
output=$(pactl list modules short | grep $PULSE_SOCKET)

# If the output is empty, module is not loaded
if [ -z "$output" ]; then
    echo "Loading PulseAudio module as it is not currently loaded."

    # Load the PulseAudio module
    pactl load-module module-native-protocol-unix socket=$PULSE_SOCKET

    # Create or overwrite the PulseAudio configuration
    cat <<EOF > $PULSE_CONF
default-server = unix:$PULSE_SOCKET
# Prevent a server running in the container
autospawn = no
daemon-binary = /bin/true
# Prevent the use of shared memory
enable-shm = false
EOF

else
    # Module is already loaded, no action needed
    echo "PulseAudio module is already loaded. No action taken."
fi
