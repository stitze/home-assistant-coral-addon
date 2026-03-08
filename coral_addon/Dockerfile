FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    python3-numpy \
    libusb-1.0-0 \
    usbutils

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Nur die Hardware-Library extrahieren
RUN apt-get update && \
    apt-get download libedgetpu1-max && \
    dpkg-deb -x libedgetpu1-max*.deb /tmp/coral && \
    cp /tmp/coral/usr/lib/aarch64-linux-gnu/libedgetpu.so.1.0 /usr/lib/libedgetpu.so.1 && \
    rm -rf /tmp/coral *.deb && \
    ldconfig

# Pip-Installation erzwingen, um kaputte System-Pakete zu ueberschreiben
RUN pip3 install --upgrade --break-system-packages tflite-runtime

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]