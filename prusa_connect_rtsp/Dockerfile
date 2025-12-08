ARG BUILD_FROM
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
    bash

# Copy application files
COPY main.py /
COPY run.sh /

RUN chmod a+x /run.sh

CMD ["/run.sh"]
