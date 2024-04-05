#!/bin/bash

# Define the container name and image name
CONTAINER_NAME="charles"
IMAGE_NAME="isaac_ros_dev-x86_64" # Replace with your specific image name

# Define the Isaac ROS development directory
ISAAC_ROS_DEV_DIR="/home/kodifly/workspaces/isaac_ros-dev" # Replace with the actual path

# Docker arguments as per your configuration
DOCKER_ARGS+=("-v /tmp/.X11-unix:/tmp/.X11-unix")
DOCKER_ARGS+=("-v $HOME/.Xauthority:/home/admin/.Xauthority:rw")
DOCKER_ARGS+=("-e DISPLAY")
DOCKER_ARGS+=("-e NVIDIA_VISIBLE_DEVICES=all")
DOCKER_ARGS+=("-e NVIDIA_DRIVER_CAPABILITIES=all")
DOCKER_ARGS+=("-e FASTRTPS_DEFAULT_PROFILES_FILE=/usr/local/share/middleware_profiles/rtps_udp_profile.xml")
DOCKER_ARGS+=("-e ROS_DOMAIN_ID")
DOCKER_ARGS+=("-e USER")
DOCKER_ARGS+=("--device=/dev/snd:/dev/snd")
DOCKER_ARGS+=("--env PULSE_SERVER=unix:/tmp/pulseaudio.socket")
DOCKER_ARGS+=("--env PULSE_COOKIE=/tmp/pulseaudio.cookie")
DOCKER_ARGS+=("--volume /tmp/pulseaudio.socket:/tmp/pulseaudio.socket")
DOCKER_ARGS+=("--volume /tmp/pulseaudio.client.conf:/etc/pulse/client.conf")


docker run -it --rm \
    --privileged \
    --network host \
    ${DOCKER_ARGS[@]} \
    -v $ISAAC_ROS_DEV_DIR:/workspaces/isaac_ros-dev \
    -v /dev/*:/dev/* \
    -v /etc/localtime:/etc/localtime:ro \
    --name "$CONTAINER_NAME" \
    --runtime nvidia \
    --user="admin" \
    --entrypoint /usr/local/bin/scripts/workspace-entrypoint.sh \
    --workdir /workspaces/isaac_ros-dev \
    $@ \
    $IMAGE_NAME \
    /bin/bash