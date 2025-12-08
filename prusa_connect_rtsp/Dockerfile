ARG BUILD_FROM
FROM $BUILD_FROM

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-numpy \
    ffmpeg \
    jq

# Install Python packages
RUN pip3 install --no-cache-dir --break-system-packages \
    opencv-python-headless \
    requests \
    "numpy<2.0"

# Copy application files
COPY main.py /
COPY run.sh /

RUN chmod a+x /run.sh

CMD ["/run.sh"]
