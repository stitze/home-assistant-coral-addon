#!/usr/bin/env bash
set -euo pipefail

MODEL_URL="https://raw.githubusercontent.com/google-coral/test_data/master/mobilenet_v2_1.0_224_inat_bird_quant_edgetpu.tflite"
MODEL_PATH="/tmp/model.tflite"
TEST_SCRIPT="/tmp/test_coral.py"

if [ ! -f "${MODEL_PATH}" ]; then
    echo "Downloading Edge TPU test model..."
    curl -fsSL "${MODEL_URL}" -o "${MODEL_PATH}"
fi

# The Edge TPU delegate needs rw access to the USB device node.
# udev rules don't run inside Docker, so we set permissions manually.
chmod -f a+rw /dev/bus/usb/*/* || true

cat > "${TEST_SCRIPT}" << 'PYEOF'
import sys
from ai_edge_litert.interpreter import Interpreter, load_delegate

print("--- Coral Stick Performance Test ---")

try:
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    interpreter.allocate_tensors()
    print("SUCCESS: Coral Edge TPU is working correctly.")
except Exception as e:
    print(f"FAILURE: {e}")
    sys.exit(1)
PYEOF

python3 "${TEST_SCRIPT}"

exec tail -f /dev/null
