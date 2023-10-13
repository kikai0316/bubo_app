import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';

Widget bottomButton({
  required BuildContext context,
  required Color backgroundColor,
  required Color textColor,
  required String text,
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        alignment: Alignment.center,
        height: safeAreaHeight * 0.065,
        width: safeAreaWidth * 0.95,
        child: nText(
          text,
          color: textColor,
          fontSize: safeAreaWidth / 27,
          bold: 700,
        ),
      ),
    ),
  );
}

Widget customButton({
  required BuildContext context,
  required Color backgroundColor,
  required Color textColor,
  required String text,
  required double textSize,
  required double height,
  required double width,
  required void Function()? onTap,
}) {
  return Material(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: nText(text, color: textColor, fontSize: textSize, bold: 700),
      ),
    ),
  );
}
