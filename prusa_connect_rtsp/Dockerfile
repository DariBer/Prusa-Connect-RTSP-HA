ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM $BUILD_FROM

# Install system dependencies and Python packages from Alpine repos
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-opencv \
    py3-numpy \
    py3-requests \
    ffmpeg \
    jq \
    bash \
    libstdc++ \
    libgomp

# Install paho-mqtt, ignoring broken version metadata from py3-opencv
RUN pip3 install --no-cache-dir --break-system-packages \
    --ignore-installed \
    paho-mqtt

# Copy application files
COPY main.py /
COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]
