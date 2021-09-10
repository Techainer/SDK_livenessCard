import 'package:flutter/material.dart';
import 'package:card_liveness/utils/recog_status.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:card_liveness/utils/recog_result_status.dart';

Widget getAlertWidget(RecogResultStatus status, var size) {
  return Container(
    height: 70,
    margin: EdgeInsets.all(size.width * 0.05),
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(6.0)),
    child: Row(
      children: <Widget>[
        // Image.asset('Group_20.png', width: 60),
        status.warningIcon,
        SizedBox(
          width: 20,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                status.title,
                // "No Card detected",
                style: boldTextStyle(
                  size: 18,
                  color: getColorFromHex("#FFFFFF"),
                ),
              ),
              Text(
                status.message,
                // "Position your Card inside the frame",
                style: primaryTextStyle(
                  size: 12,
                  color: getColorFromHex("#FFFFFF"),
                ),
              )
            ],
          ),
        ).paddingTop(9)
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 9),
  );
}
