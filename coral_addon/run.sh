#!/usr/bin/env bash
set -e

echo "--- Coral Stick Performance Test ---"

# 1. Hardware Detection
if lsusb | grep -qi "1a6e"; then
    echo "Hardware found!"
else
    echo "Hardware not found! Exit."
    exit 1
fi

# 2. Download Test Assets
echo "Downloading test model and image..."
curl -sL https://raw.githubusercontent.com/google-coral/test-data/master/mobilenet_v2_1.0_224_inat_bird_device_solution_edgetpu.tflite -o /tmp/model.tflite
curl -sL https://raw.githubusercontent.com/google-coral/test-data/master/bird.bmp -o /tmp/bird.bmp

# 3. Python Inference Script
echo "Starting inference test..."
python3 << END
import time
import numpy as np
from tflite_runtime.interpreter import Interpreter, load_delegate

# Initialize the Coral TPU
try:
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate('libedgetpu.so.1')]
    )
    interpreter.allocate_tensors()
    print("Edge TPU Delegate successfully loaded!")

    # Performance Test
    start = time.perf_counter()
    interpreter.invoke()
    end = time.perf_counter()
    print(f"Inference speed: {(end - start) * 1000:.2f} ms")

except Exception as e:
    print(f"Error during inference: {e}")
END

echo "--- Test finished. Add-on remains active. ---"
exec tail -f /dev/null