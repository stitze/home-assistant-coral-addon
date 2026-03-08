FROM ghcr.io/home-assistant/aarch64-base-debian:bookworm

RUN apt-get update && apt-get install -y gnupg2 ca-certificates curl python3 python3-pip

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && apt-get install -y libedgetpu1-std

RUN pip3 install --break-system-packages \
    https://github.com/google-coral/pycoral/releases/download/v2.0.0/pycoral-2.0.0-cp311-cp311-linux_aarch64.whl \
    tflite-runtime==2.5.0.post1

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
