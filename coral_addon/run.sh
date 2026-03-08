#!/usr/bin/env bash
set -e

echo "--- Coral Stick Hardware Test ---"

# Hardware Check
if lsusb | grep -qi "Google"; then
    echo "Hardware found!"
else
    echo "Hardware not found! Please check the USB connection."
fi

# Software Check
python3 -c "import tflite_runtime.interpreter as tflite; print('Software Check: TFLite Runtime successfully loaded!')"

# Keep the container running
echo "--- Test finished. Add-on remains active. ---"
exec tail -f /dev/null