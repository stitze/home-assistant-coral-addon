FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

# 1. System-Tools und Build-Essentials (für Python-Kompilierung)
RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libusb-1.0-0-dev

# 2. Google Coral Repo & Treiber
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y libedgetpu1-std

# 3. Spezifische Python-Wheels (um Kompilier-Fehler zu vermeiden)
RUN pip3 install --break-system-packages \
    tflite-runtime==2.14.0

RUN pip3 install --break-system-packages \
    --extra-index-url https://google-coral.github.io/py-repo/ \
    pycoral

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]