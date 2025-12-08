#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json
PIDS=()

# Get number of cameras
CAMERAS_COUNT=$(jq '.cameras | length' $CONFIG_PATH)
bashio::log.info "Found ${CAMERAS_COUNT} camera(s) configured"

# Iterate over each camera
for (( i=0; i<CAMERAS_COUNT; i++ )); do
    CAMERA_NAME=$(jq -r ".cameras[$i].name" $CONFIG_PATH)

    # Export environment variables for Python script
    export RTSP_URL=$(jq -r ".cameras[$i].rtsp_url" $CONFIG_PATH)
    export TOKEN=$(jq -r ".cameras[$i].token" $CONFIG_PATH)
    export FINGERPRINT=$(jq -r ".cameras[$i].fingerprint" $CONFIG_PATH)
    export UPLOAD_INTERVAL=$(jq -r ".cameras[$i].upload_interval" $CONFIG_PATH)
    export ENABLE_TIMELAPSE=$(jq -r ".cameras[$i].timelapse_enabled" $CONFIG_PATH)
    export TIMELAPSE_SAVE_INTERVAL=$(jq -r ".cameras[$i].timelapse_save_interval // 30" $CONFIG_PATH)
    export TIMELAPSE_FPS=$(jq -r ".cameras[$i].timelapse_fps // 24" $CONFIG_PATH)
    export TIMELAPSE_DIR="/share/prusa_connect_rtsp/${CAMERA_NAME// /_}"

    mkdir -p "$TIMELAPSE_DIR"

    bashio::log.info "Starting camera: ${CAMERA_NAME}"
    python3 /main.py &
    PIDS+=($!)
done

# Wait for all processes
wait "${PIDS[@]}"
