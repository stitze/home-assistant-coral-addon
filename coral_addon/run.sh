#!/usr/bin/env bash
set -e

echo "--- Coral Stick Performance Test ---"

if lsusb | grep -qi "1a6e"; then
    echo "Hardware found!"
else
    echo "Hardware not found! Exit."
    exit 1
fi

echo "Downloading test model..."
curl -sL https://raw.githubusercontent.com/google-coral/test-data/master/mobilenet_v2_1.0_224_inat_bird_device_solution_edgetpu.tflite -o /tmp/model.tflite

echo "Starting inference test..."
python3 << END
import time
from tflite_runtime.interpreter import Interpreter, load_delegate

try:
    # Attempting to load the delegate
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    interpreter.allocate_tensors()
    print("Edge TPU Delegate successfully loaded!")

    start = time.perf_counter()
    interpreter.invoke()
    end = time.perf_counter()
    print(f"Inference speed: {(end - start) * 1000:.2f} ms")

except Exception as e:
    print(f"Error during inference: {e}")
END

echo "--- Test finished. Add-on remains active. ---"
exec tail -f /dev/null