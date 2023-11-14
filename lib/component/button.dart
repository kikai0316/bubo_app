import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
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
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    color: Colors.grey.withOpacity(0.2),
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        height: safeAreaHeight * 0.05,
        width: safeAreaWidth * 0.4,
        decoration: BoxDecoration(
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

Widget shadowButton(
  BuildContext context, {
  required String text,
  required void Function() onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: safeAreaHeight * 0.065,
      width: safeAreaWidth * 0.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
          colors: [blueColor2, blueColor],
        ),
        boxShadow: [
          BoxShadow(
            color: blueColor2.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: nText(
        text,
        color: Colors.white,
        fontSize: safeAreaWidth / 27,
        bold: 700,
      ),
    ),
  );
}

Widget dialogButton(
  BuildContext context, {
  required String title,
  required Color backGroundColor,
  required Color textColor,
  required BoxBorder? border,
  required void Function() onTap,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return Material(
    color: backGroundColor,
    borderRadius: BorderRadius.circular(50),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        alignment: Alignment.center,
        height: safeAreaHeight * 0.055,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(50),
        ),
        child: nText(
          title,
          color: textColor,
          fontSize: safeAreaWidth / 29,
          bold: 700,
        ),
      ),
    ),
  );
}
