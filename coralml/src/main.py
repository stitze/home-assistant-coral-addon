import os
from loguru import logger
from tflite_runtime.interpreter import Interpreter, load_delegate

logger.info("Starting inference engine")

use_coral = os.environ.get("USE_CORAL", "1") == "1"

def load_model():
    if use_coral:
        return Interpreter(
            model_path="/data/model_edgetpu.tflite",
            experimental_delegates=[load_delegate("libedgetpu.so.1")]
        )
    return Interpreter(model_path="/data/model.tflite")

try:
    interpreter = load_model()
    interpreter.allocate_tensors()
    logger.info("Model loaded")
except Exception as e:
    logger.error(f"Model load failed: {e}")
