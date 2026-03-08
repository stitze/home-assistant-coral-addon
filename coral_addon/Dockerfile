FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | \
    tee /etc/apt/sources.list.d/coral-edgetpu.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && apt-get install -y \
    libedgetpu1-std \
    python3-pycoral

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]