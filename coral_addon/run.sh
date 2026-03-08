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
from ai_edge_litert.interpreter import Interpreter, load_delegate

print("--- Coral Stick Performance Test ---")

interpreter = Interpreter(
    model_path="/tmp/model.tflite",
    experimental_delegates=[load_delegate("libedgetpu.so.1")]
)
interpreter.allocate_tensors()
print("SUCCESS: Coral Edge TPU is working correctly.")
PYEOF

# Attempt 1: device may not have firmware yet
chmod -f a+rw /dev/bus/usb/*/* || true
if python3 "${TEST_SCRIPT}"; then
    exec tail -f /dev/null
fi

# Attempt 2: libedgetpu uploaded firmware and the stick re-enumerated.
# We must start a fresh Python process - reinitializing libedgetpu in the
# same process causes a segfault.
echo "INFO: First attempt failed, waiting for device re-enumeration..."
sleep 3
chmod -f a+rw /dev/bus/usb/*/* || true

if python3 "${TEST_SCRIPT}"; then
    exec tail -f /dev/null
fi

echo "FAILURE: Coral Edge TPU could not be initialized after re-enumeration."
exit 1