ARG BUILD_FROM=ghcr.io/home-assistant/{arch}-base:latest
FROM $BUILD_FROM


RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-numpy \
    libusb \
    usbutils \
    bash

RUN pip3 install --no-cache-dir \
    tflite-runtime \
    paho-mqtt \
    loguru

WORKDIR /usr/src/app

COPY src/ /usr/src/app/
COPY run.sh /run.sh

RUN chmod +x /run.sh

CMD ["/run.sh"]
