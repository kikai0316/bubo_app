import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';

Widget bottomButton({
  required BuildContext context,
  required bool isWhiteMainColor,
  required String text,
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    color: isWhiteMainColor ? Colors.white : Colors.black,
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
          color: isWhiteMainColor ? Colors.black : Colors.white,
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

Widget borderButton({
  required BuildContext context,
  required String text,
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        alignment: Alignment.center,
        height: safeAreaHeight * 0.065,
        width: safeAreaWidth * 0.95,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        child: nText(
          text,
          color: Colors.white,
          fontSize: safeAreaWidth / 27,
          bold: 700,
        ),
      ),
    ),
  );
}

Widget miniButton({
  required BuildContext context,
  required String text,
  required Color color,
  required bool isBoarder,
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    color: color,
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        height: safeAreaHeight * 0.05,
        width: safeAreaWidth * 0.4,
        decoration: BoxDecoration(
          border: isBoarder ? Border.all(color: Colors.white) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: nText(
          text,
          color: Colors.white,
          fontSize: safeAreaWidth / 30,
          bold: 700,
        ),
      ),
    ),
  );
}
