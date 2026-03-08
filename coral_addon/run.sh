from tflite_runtime.interpreter import Interpreter, load_delegate
# ...
interpreter = Interpreter(
    model_path="/tmp/model.tflite",
    experimental_delegates=[load_delegate("libedgetpu.so.1")]
)