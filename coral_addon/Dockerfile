FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

# Install bash explicitly first so the run.sh shebang (#!/usr/bin/env bash) resolves correctly
RUN apt-get update && apt-get install -y \
    bash gnupg2 ca-certificates curl python3 python3-pip python3-numpy libusb-1.0-0 usbutils

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get download libedgetpu1-max && \
    dpkg-deb -x libedgetpu1-max*.deb /tmp/coral && \
    cp /tmp/coral/usr/lib/aarch64-linux-gnu/libedgetpu.so.1.0 /usr/lib/libedgetpu.so.1 && \
    rm -rf /tmp/coral *.deb && \
    ldconfig

# tflite-runtime is broken on Python 3.11+ (missing _pywrap_tensorflow_interpreter_wrapper).
# ai-edge-litert is Google's official replacement with full Edge TPU delegate support.
RUN find /usr/lib/python3/dist-packages -name "*tflite_runtime*" -exec rm -rf {} + && \
    pip3 install --no-cache-dir --break-system-packages ai-edge-litert

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]