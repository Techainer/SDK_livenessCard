import 'package:card_liveness/utils/recog_result_status.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:card_liveness/widget/alert_result_widget.dart';
import 'dart:typed_data';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // Uint8List bytes = base64Decode(BASE64_STRING);
  RecogResultStatus recogResultStatus = RecogResultStatus.blurryCard;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Verify your identity",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: getBody(),
    );
  }

  getBody() {
    var size = MediaQuery.of(context).size;
    List<double> cardBoudingBox = computeCardBoudingBox(size);
    return SafeArea(
      bottom: false,
      top: false,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: (cardBoudingBox[1] - 100)),
                child: getAlertWidget(recogResultStatus, size),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: cardBoudingBox[1],
                      left: cardBoudingBox[0],
                      right: cardBoudingBox[0]),
                  child: Container(
                    height: cardBoudingBox[3],
                    width: cardBoudingBox[2],
                    decoration: BoxDecoration(
                      color: gray,
                      image: DecorationImage(
                        image: AssetImage('card_demo.jpg'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.1),
                child: Container(
                  height: size.height * 0.2,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Make sure your details are clear and unobstructed",
                        textAlign: TextAlign.center,
                        style: secondaryTextStyle(size: 18),
                      ),
                      SizedBox(height: size.height*0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Column contents vertically,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Column contents horizontally,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              minimumSize: Size(size.width * 0.40, 40),
                              shape: RoundedRectangleBorder(
                                // borderRadius: BorderRadius.circular(6),
                                side: BorderSide(
                                  color: getColorFromHex('#8998FF'),
                                ),
                              ),
                            ),
                            child: Text(
                              "Retake",
                              style: boldTextStyle(
                                  color: getColorFromHex("#2D88FF"), size: 20),
                            ),
                          ),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                backgroundColor: getColorFromHex("#2D88FF"),
                                primary: getColorFromHex('#8998FF'),
                                minimumSize: Size(size.width * 0.40, 40)),
                            child: Text(
                              "Confirm",
                              style:
                                  boldTextStyle(color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> computeCardBoudingBox(var rect) {
    const _CARD_ASPECT_RATIO = 1 / 1.5;
    const _OFFSET_X_FACTOR = 0.05;
    final offsetX = rect.width * _OFFSET_X_FACTOR;
    final cardWidth = rect.width - offsetX * 2;
    final cardHeight = cardWidth * _CARD_ASPECT_RATIO;
    final offsetY = (rect.height - cardHeight) / 2;
    return [offsetX, offsetY, cardWidth, cardHeight];
  }
}
