
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:flutter/material.dart';

Widget text(context, text, size, color,
    {bold = false, alignText = TextAlign.start, maxLines = 2}) {
  return Text(
    text,
    textAlign: alignText,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: color,
      fontSize: dynamicWidth(context, size),
      fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
    ),
  );
}
