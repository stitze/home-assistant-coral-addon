#!/usr/bin/env bash

if [ ! -f "/tmp/model.tflite" ]; then
    curl -sL https://raw.githubusercontent.com/google-coral/test-data/master/mobilenet_v2_1.0_224_inat_bird_device_solution_edgetpu.tflite -o /tmp/model.tflite
fi

python3 << 'EOF'
import sys
import os
try:
    from tflite_runtime.interpreter import Interpreter, load_delegate
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    interpreter.allocate_tensors()
    print("SUCCESS")
except Exception as e:
    print(f"FAILURE: {e}")
    print(f"Path: {sys.path}")
EOF

exec tail -f /dev/null