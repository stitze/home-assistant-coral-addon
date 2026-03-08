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

# Absolute path to the library
LIB_PATH = "/usr/lib/libedgetpu.so.1"

try:
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate(LIB_PATH)]
    )
    interpreter.allocate_tensors()
    print("Edge TPU Delegate successfully loaded!")

    # Run 10 iterations to get a stable average
    latencies = []
    for _ in range(10):
        start = time.perf_counter()
        interpreter.invoke()
        latencies.append(time.perf_counter() - start)
    
    avg_ms = (sum(latencies) / len(latencies)) * 1000
    print(f"Average Inference speed: {avg_ms:.2f} ms")

except Exception as e:
    print(f"Error during inference: {e}")
END

echo "--- Test finished. Add-on remains active. ---"
exec tail -f /dev/null