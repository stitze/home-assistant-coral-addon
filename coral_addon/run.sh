#!/usr/bin/env bash
set -euo pipefail

MODEL_URL="https://raw.githubusercontent.com/google-coral/test_data/master/mobilenet_v2_1.0_224_inat_bird_quant_edgetpu.tflite"
MODEL_PATH="/tmp/model.tflite"
TEST_SCRIPT="/tmp/test_coral.py"

if [ ! -f "${MODEL_PATH}" ]; then
    echo "Downloading Edge TPU test model..."
    curl -fsSL "${MODEL_URL}" -o "${MODEL_PATH}"
fi

cat > "${TEST_SCRIPT}" << 'PYEOF'
import sys
from pycoral.utils.edgetpu import make_interpreter

print("--- Coral Stick Performance Test ---")

interpreter = make_interpreter("/tmp/model.tflite")
interpreter.allocate_tensors()
print("SUCCESS: Coral Edge TPU is working correctly.")
PYEOF

# Attempt 1 - device may still need firmware upload
chmod -f a+rw /dev/bus/usb/*/* || true
if python3 "${TEST_SCRIPT}"; then
    exec tail -f /dev/null
fi

# Attempt 2 - after firmware upload the stick re-enumerates; use a fresh
# Python process (reinitializing libedgetpu in the same process segfaults)
echo "INFO: Waiting for device re-enumeration..."
sleep 3
chmod -f a+rw /dev/bus/usb/*/* || true

if python3 "${TEST_SCRIPT}"; then
    exec tail -f /dev/null
fi

echo "FAILURE: Coral Edge TPU could not be initialized."
exit 1
