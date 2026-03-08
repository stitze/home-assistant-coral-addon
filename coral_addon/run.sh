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
import sys, ctypes, subprocess

print("--- Coral Stick Performance Test ---")

# Step 1: check if libedgetpu.so.1 can be opened at all
try:
    ctypes.CDLL("libedgetpu.so.1")
    print("OK: libedgetpu.so.1 opened via ctypes")
except OSError as e:
    print(f"FAILURE: libedgetpu.so.1 could not be opened: {e}")
    result = subprocess.run(["find", "/usr/lib", "-name", "libedgetpu.so*"], capture_output=True, text=True)
    for lib in result.stdout.strip().split("\n"):
        if lib:
            ldd = subprocess.run(["ldd", lib.strip()], capture_output=True, text=True)
            print(f"ldd {lib}:\n{ldd.stdout}{ldd.stderr}")
    sys.exit(1)

# Step 2: import ai_edge_litert
try:
    from ai_edge_litert.interpreter import Interpreter, load_delegate
    print("OK: ai_edge_litert imported")
except ImportError as e:
    print(f"FAILURE: Could not import ai_edge_litert: {e}")
    sys.exit(1)

# Step 3: load delegate + run model
try:
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    interpreter.allocate_tensors()
    print("SUCCESS: Coral Edge TPU is working correctly.")
except Exception as e:
    print(f"FAILURE: delegate loaded but device error: {e}")
    usb = subprocess.run(["lsusb"], capture_output=True, text=True)
    print(f"USB devices:\n{usb.stdout or '(lsusb not available)'}")
    sys.exit(1)
PYEOF

python3 "${TEST_SCRIPT}"

exec tail -f /dev/null
