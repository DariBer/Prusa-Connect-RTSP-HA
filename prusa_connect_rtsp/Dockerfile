ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM $BUILD_FROM

# Install system dependencies and Python packages from Alpine repos
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-numpy \
    py3-requests \
    ffmpeg \
    jq \
    bash \
    libstdc++ \
    libgomp

# Install Python packages via pip (avoids Alpine's broken opencv version string)
RUN pip3 install --no-cache-dir --break-system-packages \
    opencv-python-headless \
    paho-mqtt

# Copy application files
COPY main.py /
COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]
