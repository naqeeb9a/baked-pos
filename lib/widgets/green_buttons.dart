import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

Widget greenButtons(context, text1, snapshot, index, {function = ""}) {
  return InkWell(
    onTap: function == "" ? () {} : function,
    child: Container(
      alignment: Alignment.center,
      width: dynamicWidth(context, 0.3),
      padding: EdgeInsets.all(
        dynamicWidth(context, 0.03),
      ),
      decoration: BoxDecoration(
        color: myGreen,
        borderRadius: BorderRadius.circular(
          dynamicWidth(context, 0.01),
        ),
      ),
      child: FittedBox(
        child: text(
          context,
          text1,
          0.035,
          myWhite,
        ),
      ),
    ),
  );
}
