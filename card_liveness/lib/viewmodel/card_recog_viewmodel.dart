import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:card_liveness/utils/recog_isolate.dart';
import 'dart:isolate';
import 'dart:async';


class CardRecogViewModel {
  Model? _mobileNet;
  bool isRecog = true;
  late imglib.PngEncoder pngEncoder;
  late RecogIsolate recogIsolate;
  late ReceivePort _receivePort = ReceivePort();

  CardRecogViewModel() {
    pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
    recogIsolate = RecogIsolate();
    recogIsolate.start();
    loadModel();
  }

  listenDetect() async {
    final Stream<dynamic> receiveBroadcast = _receivePort.asBroadcastStream();
    StreamSubscription<dynamic> subscription;
    subscription = receiveBroadcast.listen(
      (dynamic result) {
        var status = result.first;
        if (status == 1) {
          int maxScoreIndex = result[1];
          print("max index = $maxScoreIndex");
          // _isDetecting = false;
        }
      },
    );
  }

  Future loadModel() async {
    String mobileNetV2 = "assets/models/mobilenet-v2.pt";
    String resNetV2 = "assets/models/resnet50_scripted.pt";
    print("fluttercheck: $mobileNetV2");
    try {
      print("load mobilenet ");
      _mobileNet = await PyTorchMobile.loadModel(resNetV2);
      isRecog = false;
    } on PlatformException {
      print("only supported for android and ios so far");
    }
  }

  runRecog(CameraImage cameraImage) async {
    if (isRecog || recogIsolate.sendPort == null) return;
    isRecog = true;
    var isolateData = IsolateData(cameraImage, _mobileNet!.index);
        recogIsolate.sendPort!
        .send(isolateData..responsePort = _receivePort.sendPort);

    // isRecog = false;
  }
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
