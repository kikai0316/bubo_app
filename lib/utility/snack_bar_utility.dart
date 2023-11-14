import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/main.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void errorSnackbar({
  required String text,
  required double? padding,
}) {
  final context = navigatorKey.currentState!.overlay!.context;
  final safeAreaWidth = MediaQuery.of(context).size.width;
  // ignore: avoid_dynamic_calls
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      elevation: 0,
      margin: padding == null
          ? null
          : EdgeInsets.only(
              bottom: padding,
              left: safeAreaWidth * 0.03,
              right: safeAreaWidth * 0.03,
            ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: safeAreaWidth / 25,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: safeAreaWidth / 20,
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
    ),
  );
}

void messageSnackbar({
  required String name,
  required String messageText,
  required String id,
}) {
  final context = navigatorKey.currentState!.overlay!.context;
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  HapticFeedback.vibrate();
  Flushbar(
    onTap: (value) =>
        screenTransitionNormal(context, MessageScreenPage(id: id)),
    backgroundColor: Colors.black,
    padding: EdgeInsets.only(
      left: safeAreaWidth * 0.03,
      right: safeAreaWidth * 0.03,
      top: safeAreaHeight * 0.005,
      bottom: safeAreaHeight * 0.005,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.only(
      top: safeAreaHeight * 0.01,
      right: safeAreaWidth * 0.03,
      left: safeAreaWidth * 0.03,
    ),
    borderRadius: BorderRadius.circular(15),
    messageText: SizedBox(
      width: safeAreaWidth * 1,
      child: Padding(
        padding: EdgeInsets.all(
          safeAreaHeight * 0.01,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: safeAreaWidth * 0.03),
              child: Icon(
                Icons.local_fire_department,
                color: greenColor,
                size: safeAreaWidth / 13,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nText(
                    "新着メッセージ",
                    color: greenColor,
                    fontSize: safeAreaWidth / 40,
                    bold: 700,
                  ),
                  nText(
                    name,
                    color: Colors.white,
                    fontSize: safeAreaWidth / 30,
                    bold: 700,
                  ),
                  nText(
                    messageText,
                    color: Colors.grey,
                    fontSize: safeAreaWidth / 30,
                    bold: 700,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: safeAreaWidth * 0.05),
              child: nText(
                "返信",
                color: greenColor,
                fontSize: safeAreaWidth / 25,
                bold: 700,
              ),
            ),
          ],
        ),
      ),
    ),
    duration: const Duration(seconds: 2),
  ).show(context);
}

void encounterSnackbar({required String name, required int count}) {
  final context = navigatorKey.currentState!.overlay!.context;
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  HapticFeedback.vibrate();
  Flushbar(
    backgroundColor: Colors.black,
    padding: EdgeInsets.only(
      left: safeAreaWidth * 0.03,
      right: safeAreaWidth * 0.03,
      top: safeAreaHeight * 0.01,
      bottom: safeAreaHeight * 0.01,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.only(
      right: safeAreaWidth * 0.03,
      left: safeAreaWidth * 0.03,
    ),
    borderRadius: BorderRadius.circular(15),
    messageText: SizedBox(
      width: safeAreaWidth * 1,
      child: Padding(
        padding: EdgeInsets.all(
          safeAreaHeight * 0.02,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: safeAreaWidth * 0.03),
              child: Icon(
                Icons.celebration,
                color: blueColor,
                size: safeAreaWidth / 15,
              ),
            ),
            Expanded(
              child: Text(
                "$nameさんと$count回目の出会いです",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontVariations: const [FontVariation("wght", 700)],
                  color: blueColor,
                  fontSize: safeAreaWidth / 28,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    duration: const Duration(seconds: 2),
  ).show(context);
}
