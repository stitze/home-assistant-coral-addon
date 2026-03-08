FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    libusb-1.0-0 \
    usbutils

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Installation via Paketmanager umgeht den pip-Versionskonflikt
RUN apt-get update && \
    apt-get download libedgetpu1-max python3-tflite-runtime && \
    dpkg-deb -x libedgetpu1-max*.deb /tmp/coral && \
    dpkg-deb -x python3-tflite-runtime*.deb /tmp/coral && \
    cp /tmp/coral/usr/lib/aarch64-linux-gnu/libedgetpu.so.1.0 /usr/lib/libedgetpu.so.1 && \
    cp -r /tmp/coral/usr/lib/python3/dist-packages/* /usr/lib/python3/dist-packages/ && \
    rm -rf /tmp/coral *.deb && \
    ldconfig

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]