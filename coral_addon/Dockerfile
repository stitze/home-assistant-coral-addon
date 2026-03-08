FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

RUN apt-get update && apt-get install -y \
    gnupg2 \
    ca-certificates \
    curl \
    python3 \
    python3-pip

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && apt-get install -y libedgetpu1-std

# Wir installieren pycoral über den Google-Index statt über einen direkten GitHub-Link
RUN pip3 install --break-system-packages \
    --extra-index-url https://google-coral.github.io/py-repo/ \
    pycoral tflite-runtime

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
