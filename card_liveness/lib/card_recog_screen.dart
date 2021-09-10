import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:card_liveness/widget/cardScanner.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:card_liveness/utils/recog_status.dart';
import 'package:card_liveness/widget/alert_widget.dart';
import 'package:card_liveness/viewmodel/card_recog_viewmodel.dart';
class CardRecogScreen extends StatefulWidget {
  CardRecogScreen({Key? key}) : super(key: key);

  @override
  _CardRecogScreenState createState() => _CardRecogScreenState();
}

class _CardRecogScreenState extends State<CardRecogScreen> {
  CameraController? cameraController;
  bool isCameraReady = false;
  RecogStatus recogStatus = RecogStatus.strangeObject;
  late CardRecogViewModel cardRecogViewModel;

  @override
  void initState() {
    super.initState();
    cardRecogViewModel = new CardRecogViewModel();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (cameraController != null) cameraController!.dispose();
    final cameras = await availableCameras();
    final firstCamera = cameras[0];
    cameraController = CameraController(firstCamera, ResolutionPreset.medium,
        enableAudio: false);

    cameraController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController!.value.hasError) {
      print('Camera Error ${cameraController!.value.errorDescription}');
    }

    try {
      await cameraController!.initialize().then((_) => {
            setState(() {
              isCameraReady = true;
            })
          });
    } catch (e) {
      print('Camera Error ${e}');
    }

    if (mounted) {
      setState(() {});
    }

    cameraController!.startImageStream((CameraImage image) {
      cardRecogViewModel.runRecog(image);
    });
  }

  @override
  void dispose() {
    this.cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: getBody(),
    );
  }

  getBody() {
    var size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    if (isCameraReady) {
      return SafeArea(
        bottom: false,
        top: false,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(color: Colors.red),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CameraPreview(cameraController!),
              // Center(
              //   child: Transform.scale(
              //     scale: cameraController!.value.aspectRatio / deviceRatio,
              //     child: new AspectRatio(
              //       aspectRatio: cameraController!.value.aspectRatio,
              //       child: new CameraPreview(cameraController!),
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.17),
                  child: getAlertWidget(recogStatus, size),
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: CardScannerOverlayShape(
                    borderColor: recogStatus.color,
                    borderRadius: 6,
                    borderLength: 32,
                    borderWidth: 4,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.1),
                  child: Container(
                      height: 70,
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Identity Card",
                            style: primaryTextStyle(
                              size: 20,
                              color: getColorFromHex("#FFFFFF"),
                            ),
                          ),
                          SizedBox(height:5),
                          Text(
                            "Front",
                            style: primaryTextStyle(
                              size: 15,
                              color: getColorFromHex("#FFFFFF"),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
