import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as imglib;
import 'dart:typed_data';

class CardLiveness {
  Interpreter? _interpreter;
  NormalizeOp _normalizeOp = NormalizeOp(127.5, 127.5);
  ImageProcessor? _imageProcessor;

  CardLiveness({Interpreter? interpreter}) {
    _loadModel(interpreter: interpreter);
  }

  CardLiveness.fromAddress(int interpreterAddress) {
    _loadModel(interpreter: Interpreter.fromAddress(interpreterAddress));
  }

  void _loadModel({Interpreter? interpreter}) async {
    if (interpreter == null) {
      if (Platform.isAndroid) {
        print("init model");
        final gpuDelegateV2 = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
          isPrecisionLossAllowed: false,
          inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
          inferencePriority1: TfLiteGpuInferencePriority.minLatency,
          inferencePriority2: TfLiteGpuInferencePriority.auto,
          inferencePriority3: TfLiteGpuInferencePriority.auto,
        ));
        var interpreterOptions = InterpreterOptions()
          ..addDelegate(gpuDelegateV2);
        try {
          _interpreter = await Interpreter.fromAsset('models/idcard.tflite',
              options: interpreterOptions);
        } catch (e) {
          print("Error while creating interpreter: $e");
        }
      } else {
        try {
          _interpreter = await Interpreter.fromAsset('models/idcard.tflite');
        } catch (e) {
          print("Error while creating interpreter: $e");
        }
      }
    } else {
      _interpreter = interpreter;
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage, List<int> _inputShape) {
    if (_imageProcessor == null) {
      double mean = _meanOf(inputImage.getBuffer().asFloat32List());
      double std = _stdOf(inputImage.getBuffer().asFloat32List(), mean);
      _imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(
              _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
          .add(NormalizeOp(mean, std))
          .build();
    }
    inputImage = _imageProcessor!.process(inputImage);
    return inputImage;
  }

  List<double>? predict(imglib.Image image) {
    if (_interpreter == null) {
      print("Interpreter not initialized");
      return null;
    }
    var startPreprocessForDetect = DateTime.now().millisecondsSinceEpoch;
    TensorImage imageTensor = TensorImage(TfLiteType.float32);
    imageTensor.loadImage(image);
    imageTensor =
        getProcessedImage(imageTensor, _interpreter!.getInputTensor(0).shape);
    print("hubert: tensor output = ${_interpreter!.getInputTensor(0).shape}");

    TensorBuffer _output = TensorBuffer.createFixedSize(
        _interpreter!.getOutputTensor(0).shape,
        _interpreter!.getOutputTensor(0).type);
    Map<int, ByteBuffer> outputs = {0: _output.buffer};
    var endPreprocessForDetect = DateTime.now().millisecondsSinceEpoch;
    print(
        "preprocess time for recog: ${(endPreprocessForDetect - startPreprocessForDetect) / 1000}");
    var startDetectTime = DateTime.now().millisecondsSinceEpoch;

    _interpreter!.runForMultipleInputs([imageTensor.buffer], outputs);

    var endDetectTime = DateTime.now().millisecondsSinceEpoch;
    print("Recog time: ${(endDetectTime - startDetectTime) / 1000}");

    return outputs[0]!.asFloat32List();
  }

  Interpreter? get interpreter => _interpreter;
}

double _meanOf(List<double> imageBufferList) {
  return imageBufferList.reduce((a, b) => a + b) / imageBufferList.length;
}

double _stdOf(List<double> imageBufferList, double mean) {
  double variance = 0;
  imageBufferList.forEach((element) {
    variance = variance + _abs(element - mean) * _abs(element - mean);
  });
  variance = variance / (imageBufferList.length - 1);
  return sqrt(variance);
}

double _abs(double x) {
  return x < 0 ? -x : x;
}
