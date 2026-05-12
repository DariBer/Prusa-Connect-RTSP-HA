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

# Remove broken opencv dist-info so pip can install without crashing,
# then install paho-mqtt directly with pip bypassing the package index
RUN rm -rf /usr/lib/python3*/site-packages/opencv* && \
    pip3 install --no-cache-dir --break-system-packages \
    --no-deps paho-mqtt

# Copy application files
COPY main.py /
COPY run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]
