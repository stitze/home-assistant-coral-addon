FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

# 1. System-Tools installieren
RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    libusb-1.0-0 \
    usbutils

# 2. Coral Repo hinzufügen
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# 3. Treiber mit Workaround für 'exit status 30' installieren
RUN apt-get update && \
    (echo 'libedgetpu1-max libedgetpu/install-udev-rules boolean false' | debconf-set-selections) && \
    apt-get install -y libedgetpu1-max

# 4. Library verlinken
RUN ln -s /usr/lib/aarch64-linux-gnu/libedgetpu.so.1.0 /usr/lib/libedgetpu.so.1 && ldconfig

# 5. TFLite installieren
RUN pip3 install --break-system-packages tflite-runtime==2.14.0

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]