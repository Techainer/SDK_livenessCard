import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import './guide_page.dart';

class Walthrough extends StatefulWidget {
  Walthrough({Key? key}) : super(key: key);

  @override
  _WalthroughState createState() => _WalthroughState();
}

class _WalthroughState extends State<Walthrough> {
  String? dropdownScrollable = 'EN';

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
            Image.asset('techain_horizon.png', width: size.width * 0.6),
            Row(
              children: <Widget>[
                SizedBox(width: size.width * 0.78),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: getColorFromHex("#2D88FF"),
                        style: BorderStyle.solid,
                        width: 1.5),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.language,
                        color: getColorFromHex("#2D88FF"),
                        size: 20,
                      ),
                      Container(
                        height: 20,
                        child: DropdownButton<String>(
                          value: dropdownScrollable,
                          underline: SizedBox(),
                          style: TextStyle(color: getColorFromHex("#2D88FF")),
                          isExpanded: false,
                          dropdownColor: getColorFromHex("#FFFFFF"),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: getColorFromHex("#2D88FF"),
                          ),
                          onChanged: (String? newValue) {
                            // toast(newValue);
                            print(newValue);
                            setState(() {
                              dropdownScrollable = newValue;
                            });
                          },
                          items: <String>[
                            'EN',
                            'VI',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: primaryTextStyle())
                                // .paddingLeft(8),
                                );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Image.asset('Group_93.png', width: size.width * 0.9),
            SizedBox(height: 10),
            Text(
              'Welcome',
              style: boldTextStyle(size: 35, color: getColorFromHex("#2D88FF")),
            ),
            Text("An automatic identify verification which enables you to verify your identify",
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(size: 16))
                .paddingAll(18),
            TextButton(
              onPressed: () {
                GuideScreen().launch(context);
              },
              style: TextButton.styleFrom(
                  backgroundColor: getColorFromHex("#2D88FF"),
                  primary: getColorFromHex('#8998FF'),
                  minimumSize: Size(size.width * 0.65, 20)),
              child: Text(
                "Let's Start",
                style: primaryTextStyle(color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
