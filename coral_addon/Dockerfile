FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    libusb-1.0-0 \
    usbutils \
    libext2fs2

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get download libedgetpu1-max && \
    dpkg-deb -x libedgetpu1-max*.deb /tmp/coral && \
    cp -r /tmp/coral/* / && \
    rm -rf /tmp/coral *.deb && \
    ldconfig

RUN pip3 install --break-system-packages tflite-runtime==2.11.0

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]