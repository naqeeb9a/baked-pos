import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/config.dart';

Widget inputTextField(context, myController,
    {function,
    function2,
    keyboard = TextInputType.emailAddress,
    password = false,
    enabled = false}) {
  return Container(
    decoration:
        BoxDecoration(color: myWhite, borderRadius: BorderRadius.circular(10)),
    child: TextFormField(
      enabled:
          !enabled, //reversed because login loading variable is working in reverse
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (function == "")
          ? () {
              return null;
            }
          : function,
      controller: myController,
      textInputAction: TextInputAction.next,
      keyboardType: keyboard,
      inputFormatters: [
        keyboard == TextInputType.number
            ? FilteringTextInputFormatter.allow(
                RegExp("[0-9]"),
              )
            : FilteringTextInputFormatter.allow(
                RegExp("[a-zA-Z /:? 0-9 \\- @ _ .]"),
              ),
        keyboard == TextInputType.number
            ? FilteringTextInputFormatter.deny(
                RegExp('[\\.|\\,]'),
              )
            : FilteringTextInputFormatter.deny(
                RegExp('[\\#]'),
              ),
      ],
      obscureText: password == true ? obscureText : false,
      cursorColor: myBrown,
      cursorWidth: 2.0,
      cursorHeight: dynamicHeight(context, .03),
      style: TextStyle(
        color: myBrown,
        fontSize: dynamicWidth(context, .04),
      ),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: noColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: noColor),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: noColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: dynamicWidth(context, .05),
        ),
      ),
    ),
  );
}
