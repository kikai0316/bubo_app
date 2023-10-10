import 'package:flutter/material.dart';

double safeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
}

Widget line(
  BuildContext context, {
  required double top,
  required double bottom,
}) {
  return Padding(
    padding: EdgeInsets.only(top: top, bottom: bottom),
    child: Container(
      height: 0.2,
      width: double.infinity,
      color: Colors.grey,
    ),
  );
}
