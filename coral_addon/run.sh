#!/usr/bin/env bash

# ... (Dein Version-Bump Teil bleibt hier)

echo "--- Coral Stick Performance Test ---"

# WICHTIG: Der Python-Block muss exakt so eingeleitet werden
python3 << EOF
import time
try:
    from tflite_runtime.interpreter import Interpreter, load_delegate
    
    # Modell laden (Pfad anpassen falls noetig)
    interpreter = Interpreter(
        model_path="/tmp/model.tflite",
        experimental_delegates=[load_delegate("libedgetpu.so.1")]
    )
    print("Edge TPU Delegate erfolgreich geladen!")
except ImportError as e:
    print(f"Import-Fehler: {e}")
except Exception as e:
    print(f"Fehler: {e}")
EOF

exec tail -f /dev/null