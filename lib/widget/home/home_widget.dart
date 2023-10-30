import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/login.dart';
import 'package:flutter/material.dart';

Widget errorWidget(
  BuildContext context,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    color: blackColor,
    alignment: Alignment.topCenter,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        nText(
          "エラーが発生しました",
          color: Colors.white,
          fontSize: safeAreaWidth / 17,
          bold: 700,
        ),
        Padding(
          padding: EdgeInsets.only(top: safeAreaHeight * 0.05),
          child: nText(
            "ログイン情報が確認できませんでした。\nログインページから再度ログインを行ってください。",
            color: Colors.grey,
            fontSize: safeAreaWidth / 28,
            bold: 500,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: safeAreaHeight * 0.04,
            bottom: safeAreaHeight * 0.1,
          ),
          child: customButton(
            context: context,
            height: safeAreaHeight * 0.06,
            width: safeAreaWidth * 0.6,
            text: "ログインページへ",
            textColor: Colors.black,
            textSize: safeAreaWidth / 30,
            backgroundColor: Colors.white,
            onTap: () => screenTransitionToTop(context, const StartPage()),
          ),
        ),
      ],
    ),
  );
}

Widget searchUserWidget(
  BuildContext context, {
  required bool isOnSearch,
  required void Function() onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      height: safeAreaHeight * 0.08,
      width: safeAreaHeight * 0.08,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnSearch ? blueColor2 : const Color.fromARGB(255, 40, 45, 60),
        boxShadow: [
          BoxShadow(
            color: (isOnSearch ? blueColor2 : Colors.black).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOnSearch ? Icons.sensors : Icons.sensors_off,
            color: Colors.white,
            size: safeAreaWidth / 15,
          ),
          nText(
            isOnSearch ? "探索中" : "停止",
            color: Colors.white,
            fontSize: safeAreaWidth / 40,
            bold: 700,
          ),
        ],
      ),
    ),
  );
}
