import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:card_liveness/card_recog_screen.dart';

class GuideScreen extends StatefulWidget {
  GuideScreen({Key? key}) : super(key: key);

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30),
            Text("Verify your identity",
                style:
                    boldTextStyle(size: 30, color: getColorFromHex("#514B4B"))),
            SizedBox(
              height: 20,
            ),
            Container(
              height: size.height * 0.28,
              width: size.width,
              decoration: BoxDecoration(color: getColorFromHex("#2D88FF")),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "Supported Documents",
                    style: boldTextStyle(
                        size: 20, color: getColorFromHex("#FFFFFF")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment
                        .center, //Center Row contents vertically,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            ImageIcon(
                              AssetImage("card_white.png"),
                              color: getColorFromHex("#FFFFFF"),
                              size: 60,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Identity Card",
                              style: secondaryTextStyle(
                                  size: 16, color: getColorFromHex("#FFFFFF")),
                            )
                          ],
                        ),
                      ).paddingAll(9),
                      Container(
                        height: 80,
                        child: VerticalDivider(
                          color: Colors.white,
                          width: 5,
                          thickness: 1.5,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            ImageIcon(
                              AssetImage("passport.png"),
                              color: getColorFromHex("#FFFFFF"),
                              size: 60,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Identity Card",
                              style: secondaryTextStyle(
                                  size: 16, color: getColorFromHex("#FFFFFF")),
                            )
                          ],
                        ),
                      ).paddingAll(9),
                      Container(
                        height: 80,
                        child: VerticalDivider(
                          color: Colors.white,
                          width: 5,
                          thickness: 1.5,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        // padding:,
                        child: Column(
                          children: [
                            ImageIcon(
                              AssetImage("car.png"),
                              color: getColorFromHex("#FFFFFF"),
                              size: 60,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Identity Card",
                              style: secondaryTextStyle(
                                  size: 16, color: getColorFromHex("#FFFFFF")),
                            )
                          ],
                        ),
                      ).paddingAll(9),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Follow these tips: ",
              style: boldTextStyle(size: 20, color: getColorFromHex("#514B4B")),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Icon(
                  Icons.contact_support_rounded,
                  color: getColorFromHex("#2D88FF"),
                  size: 30,
                ),
                SizedBox(width: 15),
                ImageIcon(
                  AssetImage("card.png"),
                  color: getColorFromHex("#2D88FF"),
                  size: 55,
                ),
                SizedBox(width: 30),
                Text("Use valid card", style: secondaryTextStyle(size: 18)),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Icon(
                  Icons.contact_support_rounded,
                  color: getColorFromHex("#2D88FF"),
                  size: 30,
                ),
                SizedBox(width: 15),
                ImageIcon(
                  AssetImage("card_2.png"),
                  color: getColorFromHex("#2D88FF"),
                  size: 60,
                ),
                SizedBox(width: 25),
                Expanded(
                  child: Text(
                    'Place the card inside the frame',
                    overflow: TextOverflow.clip,
                    style: secondaryTextStyle(size: 18),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Icon(
                  Icons.contact_support_rounded,
                  color: getColorFromHex("#2D88FF"),
                  size: 30,
                ),
                SizedBox(width: 15),
                ImageIcon(
                  AssetImage("card_3.png"),
                  color: getColorFromHex("#2D88FF"),
                  size: 60,
                ),
                SizedBox(width: 25),
                Text("Avoid Glare",
                    textAlign: TextAlign.left,
                    style: secondaryTextStyle(size: 18)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                CardRecogScreen().launch(context);
              },
              style: TextButton.styleFrom(
                  backgroundColor: getColorFromHex("#2D88FF"),
                  primary: getColorFromHex('#8998FF'),
                  minimumSize: Size(size.width * 0.9, 40)),
              child: Text(
                "Got it",
                style: boldTextStyle(color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
