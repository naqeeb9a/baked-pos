import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/config.dart';

Widget coloredButton(context, text, color,
    {function = "", width = "", fontSize = 0.04}) {
  return GestureDetector(
    onTap: function == "" ? () {} : function,
    child: Container(
      width: width == "" ? dynamicWidth(context, 1) : width,
      height: dynamicWidth(context, .1),
      decoration: color == noColor
          ? BoxDecoration(
              color: color, border: Border.all(width: 1, color: myBlack))
          : BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(dynamicHeight(context, 0.02))),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: myWhite,
            fontWeight: FontWeight.bold,
            fontSize: dynamicWidth(context, fontSize),
          ),
        ),
      ),
    ),
  );
}

Widget retry(context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          "assets/retry.json",
          width: dynamicWidth(context, 0.3),
          repeat: true,
        ),
        heightBox(context, 0.02),
        text(context, "Check your internet or try again later", 0.03, myBlack),
        heightBox(context, 0.05),
        coloredButton(
          context,
          "Retry",
          myYellow,
          width: dynamicWidth(context, .3),
          function: () {
            globalRefresh();
          },
        ),
      ],
    ),
  );
}
