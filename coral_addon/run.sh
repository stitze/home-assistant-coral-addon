#!/usr/bin/env bash
set -euo pipefail

MODEL_URL="https://raw.githubusercontent.com/google-coral/test_data/master/mobilenet_v2_1.0_224_inat_bird_quant_edgetpu.tflite"
MODEL_PATH="/tmp/model.tflite"
TEST_SCRIPT="/tmp/test_coral.py"

if [ ! -f "${MODEL_PATH}" ]; then
    echo "Downloading Edge TPU test model..."
    curl -fsSL "${MODEL_URL}" -o "${MODEL_PATH}"
fi

# Set USB permissions before AND after the Coral firmware upload.
# On first access libedgetpu uploads firmware and the stick re-enumerates
# with a new device ID (1a6e:089a -> 18d1:9302), creating a new device node
# that also needs rw permissions.
chmod -f a+rw /dev/bus/usb/*/* || true

cat > "${TEST_SCRIPT}" << 'PYEOF'
import sys, time, subprocess

from ai_edge_litert.interpreter import Interpreter, load_delegate

print("--- Coral Stick Performance Test ---")

# First attempt - may trigger firmware upload and re-enumeration
try:
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    interpreter.allocate_tensors()
    print("SUCCESS: Coral Edge TPU is working correctly.")
    sys.exit(0)
except Exception:
    pass

# Device re-enumerated after firmware upload - fix permissions and retry
print("INFO: Device re-enumerated, fixing permissions and retrying...")
subprocess.run(["chmod", "-f", "a+rw"] + 
    __import__('glob').glob("/dev/bus/usb/*/*"), 
    capture_output=True)
time.sleep(2)

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
