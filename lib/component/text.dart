import 'dart:ui';

import 'package:flutter/cupertino.dart';

Widget nText(
  String text, {
  required Color color,
  required double fontSize,
  required double bold,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      decoration: TextDecoration.none,
      fontFamily: "Normal",
      fontVariations: [FontVariation("wght", bold)],
      color: color,
      fontWeight: FontWeight.w100,
      fontSize: fontSize,
    ),
  );
}

Widget nTextWithShadow(
  String text, {
  required Color color,
  required double fontSize,
  required double bold,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      shadows: const [
        Shadow(
          blurRadius: 0.8,
        ),
      ],
      decoration: TextDecoration.none,
      fontFamily: "Normal",
      fontVariations: [FontVariation("wght", bold)],
      color: color,
      fontWeight: FontWeight.w100,
      fontSize: fontSize,
    ),
  );
}
