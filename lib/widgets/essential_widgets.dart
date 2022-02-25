import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

bar(
  context, {
  function = "",
  function1 = "",
}) {
  return AppBar(
    backgroundColor: myWhite,
    title: Center(
      child: Image.asset(
        "assets/logo.png",
        color: myBlack,
        width: dynamicWidth(context, 0.24),
        fit: BoxFit.contain,
        height: dynamicHeight(context, 0.05),
      ),
    ),
    centerTitle: true,
    bottom: PreferredSize(
      child: Container(
        color: myWhite.withOpacity(0.5),
        height: 1,
      ),
      preferredSize: const Size.fromHeight(4.0),
    ),
  );
}

loader(context) {
  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(dynamicWidth(context, 0.5)),
      child: Image.asset(
        "assets/loader.gif",
        width: dynamicWidth(context, 0.3),
      ),
    ),
  );
}

loginLoader(context) {
  return LottieBuilder.asset(
    "assets/loginLoading.json",
    width: dynamicWidth(context, 0.3),
    height: dynamicHeight(context, 0.07),
  );
}
