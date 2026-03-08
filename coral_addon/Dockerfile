FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

RUN apt-get update && apt-get install -y \
    bash gnupg2 ca-certificates curl python3 python3-pip python3-numpy libusb-1.0-0 usbutils

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get download libedgetpu1-max && \
    dpkg-deb -x libedgetpu1-max*.deb /tmp/coral && \
    find /tmp/coral -name "libedgetpu.so.1.0" -exec cp {} /usr/lib/ \; && \
    ln -sf /usr/lib/libedgetpu.so.1.0 /usr/lib/libedgetpu.so.1 && \
    rm -rf /tmp/coral libedgetpu1-max*.deb && \
    ldconfig

# Remove broken system tflite_runtime, install 2.14.0 from PyPI (no version pin)
RUN find /usr/lib/python3/dist-packages -name "*tflite_runtime*" -exec rm -rf {} + && \
    pip3 install --no-cache-dir --break-system-packages tflite-runtime

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]
