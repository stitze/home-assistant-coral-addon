#!/usr/bin/env bash
# Bail out immediately on any unhandled error
set -euo pipefail

MODEL_URL="https://raw.githubusercontent.com/google-coral/test-data/master/mobilenet_v2_1.0_224_inat_bird_device_solution_edgetpu.tflite"
MODEL_PATH="/tmp/model.tflite"
TEST_SCRIPT="/tmp/test_coral.py"

# Download the test model if not already cached
if [ ! -f "${MODEL_PATH}" ]; then
    echo "Downloading Edge TPU test model..."
    curl -fsSL "${MODEL_URL}" -o "${MODEL_PATH}"
fi

# Write the test script to a real file instead of a heredoc.
# This avoids the heredoc being misinterpreted when the container runs
# run.sh under /bin/sh rather than bash.
cat > "${TEST_SCRIPT}" << 'PYEOF'
import sys

print("--- Coral Stick Performance Test ---")

try:
    # ai-edge-litert is Google's Python 3.11-compatible replacement for
    # the broken tflite-runtime PyPI package.
    from ai_edge_litert.interpreter import Interpreter, load_delegate
except ImportError as e:
    print(f"FAILURE: Could not import ai_edge_litert: {e}")
    sys.exit(1)

try:
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    interpreter.allocate_tensors()
    print("SUCCESS: Coral Edge TPU is working correctly.")
except Exception as e:
    print(f"FAILURE: {e}")
    print(f"Python path: {sys.path}")
    sys.exit(1)
PYEOF

python3 "${TEST_SCRIPT}"

# Keep the container alive so HA Supervisor sees it as running
exec tail -f /dev/null
