#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json
FINGERPRINT_DIR=/data/fingerprints
PIDS=()

# Create fingerprint storage directory
mkdir -p "$FINGERPRINT_DIR"

# Get number of cameras
CAMERAS_COUNT=$(jq '.cameras | length' $CONFIG_PATH)
bashio::log.info "Found ${CAMERAS_COUNT} camera(s) configured"

# Iterate over each camera
for (( i=0; i<CAMERAS_COUNT; i++ )); do
    CAMERA_NAME=$(jq -r ".cameras[$i].name" $CONFIG_PATH)
    CAMERA_SLUG="${CAMERA_NAME// /_}"

    # Get fingerprint from config, or auto-generate if empty
    FINGERPRINT=$(jq -r ".cameras[$i].fingerprint // empty" $CONFIG_PATH)
    if [ -z "$FINGERPRINT" ]; then
        FINGERPRINT_FILE="$FINGERPRINT_DIR/${CAMERA_SLUG}.txt"
        if [ -f "$FINGERPRINT_FILE" ]; then
            FINGERPRINT=$(cat "$FINGERPRINT_FILE")
            bashio::log.info "Using stored fingerprint for ${CAMERA_NAME}"
        else
            # Generate 40-char hex fingerprint (like SHA1 format)
            FINGERPRINT=$(cat /proc/sys/kernel/random/uuid | tr -d '-')$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 8)
            echo "$FINGERPRINT" > "$FINGERPRINT_FILE"
            bashio::log.info "Generated new fingerprint for ${CAMERA_NAME}: ${FINGERPRINT}"
        fi
    fi

    # Export environment variables for Python script
    export RTSP_URL=$(jq -r ".cameras[$i].rtsp_url" $CONFIG_PATH)
    export TOKEN=$(jq -r ".cameras[$i].token" $CONFIG_PATH)
    export FINGERPRINT
    export UPLOAD_INTERVAL=$(jq -r ".cameras[$i].upload_interval" $CONFIG_PATH)
    export ENABLE_TIMELAPSE=$(jq -r ".cameras[$i].timelapse_enabled" $CONFIG_PATH)
    export TIMELAPSE_SAVE_INTERVAL=$(jq -r ".cameras[$i].timelapse_save_interval // 30" $CONFIG_PATH)
    export TIMELAPSE_FPS=$(jq -r ".cameras[$i].timelapse_fps // 24" $CONFIG_PATH)
    export TIMELAPSE_DIR="/share/prusa_connect_rtsp/${CAMERA_SLUG}"

    mkdir -p "$TIMELAPSE_DIR"

    bashio::log.info "Starting camera: ${CAMERA_NAME}"
    python3 /main.py &
    PIDS+=($!)
done

# Wait for all processes
wait "${PIDS[@]}"
