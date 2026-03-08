#!/usr/bin/with-contenv bashio

bashio::log.info "Starting Home Assistant Coral Add-on..."

# Check for USB device
if lsusb | grep -q "Google Inc."; then
    bashio::log.info "Google Coral USB Accelerator found on USB bus."
else
    bashio::log.error "Google Coral USB Accelerator NOT detected. Check connection!"
fi

# Simple Python check for Edge TPU availability
python3 << EOF
import os
from pycoral.utils import edgetpu

try:
    devices = edgetpu.list_edge_tpus()
    if devices:
        print(f"SUCCESS: Edge TPU detected: {devices}")
    else:
        print("FAILURE: No Edge TPU devices found by pycoral.")
except Exception as e:
    print(f"ERROR: Could not initialize pycoral: {e}")
EOF

bashio::log.info "Hardware check complete. Keeping container running..."

while true; do sleep 60; done