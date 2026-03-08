FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

# 1. System-Tools installieren
RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    libusb-1.0-0

# 2. Google Coral Repo & Treiber
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y libedgetpu1-std

# 3. Python-Umgebung ohne Kompilieren (Wheels)
RUN pip3 install --break-system-packages \
    tflite-runtime==2.14.0

# Wir nutzen das offizielle Google-Repo für das Python-Modul
RUN pip3 install --break-system-packages \
    --extra-index-url https://google-coral.github.io/py-repo/ \
    pycoral

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]