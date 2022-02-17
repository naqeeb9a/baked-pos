import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/config.dart';

Widget inputTextField(context, label, myController,
    {function,
    function2,
    keyboard = TextInputType.emailAddress,
    password = false}) {
  return Container(
    color: myWhite,
    child: TextFormField(
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
        FilteringTextInputFormatter.allow(
          RegExp("[0-9]"),
        ),
        FilteringTextInputFormatter.deny(
          RegExp('[\\.|\\,]'),
        )
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
          borderSide: BorderSide(color: myBrown),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: myBrown),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: myBrown),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: dynamicWidth(context, .05),
        ),
      ),
    ),
  );
}
