import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:flutter/services.dart';


class RecogIsolate {
  static const String DEBUG_NAME = "InferenceIsolate";

  late Isolate _isolate;
  ReceivePort _receivePort = ReceivePort();
  SendPort? _sendPort;

  SendPort? get sendPort => _sendPort;

  void start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );
    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);
    late imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
    // late Model _mobileNet;
    // String resNetV2 = "assets/models/resnet50_scripted.pt";
    // try {
    //   print("load mobilenet ");
    //   _mobileNet = await PyTorchMobile.loadModel(resNetV2);
    // } on PlatformException {
    //   print("only supported for android and ios so far");
    // }
    await for (final IsolateData isolateData in port) {
      Model _mobileNet = await PyTorchMobile.loadModelByIndex(isolateData.modelIndex);
      var startTime = DateTime.now().millisecondsSinceEpoch;
      imglib.Image _img = convertYUV420(isolateData.cameraImage);
      _img = imglib.copyRotate(_img, -90);
      List<int> byteData = pngEncoder.encodeImage(_img);
      List? prediction =
          await _mobileNet.getImagePredictionListByBuffer(byteData, 248, 248);
      print("Recog result = ${prediction!}");
      double maxScore = double.negativeInfinity;
      int maxScoreIndex = -1;
      for (int i = 0; i < prediction.length; i++) {
        if (prediction[i] > maxScore) {
          maxScore = prediction[i];
          maxScoreIndex = i;
        }
      }
      var endTime = DateTime.now().millisecondsSinceEpoch;
      print("inference Time = ${endTime - startTime}");
      print("max score index = $maxScoreIndex");
      isolateData.responsePort!.send([1,maxScoreIndex]);
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int modelIndex;
  SendPort? responsePort;
  // double screenHeight;
  // double screenWidth;

  IsolateData(this.cameraImage, this.modelIndex);
}

imglib.Image convertYUV420(CameraImage cameraImage) {
  final int? width = cameraImage.width;
  final int? height = cameraImage.height;

  final int? uvRowStride = cameraImage.planes[1].bytesPerRow;
  final int? uvPixelStride = cameraImage.planes[1].bytesPerPixel;

  final image = imglib.Image(width!, height!);

  for (int w = 0; w < width; w++) {
    for (int h = 0; h < height; h++) {
      final int uvIndex =
          uvPixelStride! * (w / 2).floor() + uvRowStride! * (h / 2).floor();
      final int index = h * width + w;

      final y = cameraImage.planes[0].bytes[index];
      final u = cameraImage.planes[1].bytes[uvIndex];
      final v = cameraImage.planes[2].bytes[uvIndex];

      image.data[index] = yuv2rgb(y, u, v);
    }
  }
  return image;
}

int yuv2rgb(int y, int u, int v) {
  // Convert yuv pixel to rgb
  int r = (y + v * 1436 / 1024 - 179).round();
  int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
  int b = (y + u * 1814 / 1024 - 227).round();

  // Clipping RGB values to be inside boundaries [ 0 , 255 ]
  r = r.clamp(0, 255);
  g = g.clamp(0, 255);
  b = b.clamp(0, 255);

  return 0xff000000 | ((b << 16) & 0xff0000) | ((g << 8) & 0xff00) | (r & 0xff);
}
