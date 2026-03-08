#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
CONFIG_FILE=$(find "$REPO_ROOT" -name "config.json" -print -quit)

if [ -z "$CONFIG_FILE" ]; then
    exit 1
fi

CURRENT_VERSION=$(grep -oP '"version":\s*"\K[0-9.]+' "$CONFIG_FILE")
IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"

NEW_PATCH=$((patch + 1))
NEW_MINOR=$minor
NEW_MAJOR=$major

if [ "$NEW_PATCH" -gt 9 ]; then
    NEW_PATCH=0
    NEW_MINOR=$((minor + 1))
fi

if [ "$NEW_MINOR" -gt 9 ]; then
    NEW_MINOR=0
    NEW_MAJOR=$((major + 1))
fi

NEW_VERSION="$NEW_MAJOR.$NEW_MINOR.$NEW_PATCH"
sed -i "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" "$CONFIG_FILE"
git add "$CONFIG_FILE"

echo "--- Coral Stick Performance Test ---"
curl -sL https://raw.githubusercontent.com/google-coral/test-data/master/mobilenet_v2_1.0_224_inat_bird_device_solution_edgetpu.tflite -o /tmp/model.tflite

python3 << END
import time
from tflite_runtime.interpreter import Interpreter, load_delegate

try:
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    interpreter.allocate_tensors()
    print("Edge TPU Delegate successfully loaded!")
    
    start = time.perf_counter()
    interpreter.invoke()
    print(f"Inference speed: {(time.perf_counter() - start) * 1000:.2f} ms")
except Exception as e:
    print(f"Error: {e}")
END

exec tail -f /dev/null