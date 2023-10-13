import 'package:flutter/material.dart';

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
