#!/usr/bin/env bash
set -e

echo "--- Coral Stick Hardware Test ---"

# Search for the specific Hardware ID 1a6e:089a
if lsusb | grep -qi "1a6e:089a"; then
    echo "Hardware found (ID 1a6e:089a)!"
else
    echo "Hardware not found via lsusb!"
fi

# Python check to see if the library can talk to the stick
python3 -c "import tflite_runtime.interpreter as tflite; print('Software Check: TFLite Runtime successfully loaded!')"

echo "--- Test finished. Add-on remains active. ---"
exec tail -f /dev/null