FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

# 1. Nur die nötigsten System-Bibliotheken (keine Compiler mehr nötig!)
RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    libusb-1.0-0 \
    libglib2.0-0

# 2. Google Coral Repo & Treiber
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y libedgetpu1-std

# 3. Installation via vorkompilierten Wheels (verhindert den Fehler aus dem Screenshot)
RUN pip3 install --break-system-packages \
    tflite-runtime==2.14.0

# Dieses spezielle Wheel ist für Python 3.11 gepatcht und installiert sich sofort
RUN pip3 install --break-system-packages \
    https://github.com/hannes-hochreiner/pycoral-build/releases/download/v2.0.0/pycoral-2.0.0-cp311-cp311-linux_aarch64.whl

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]