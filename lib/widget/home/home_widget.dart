import 'dart:ui';

import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/login.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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

Widget nearbyStartWidget(
  BuildContext context, {
  required void Function() onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  InlineSpan textWidget(
    String text,
  ) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: "Normal",
        fontVariations: const [FontVariation("wght", 700)],
        color: text == "ON" ? greenColor : Colors.white,
        fontSize: safeAreaWidth / 24,
      ),
    );
  }

  return Container(
    height: double.infinity,
    width: double.infinity,
    color: Colors.black.withOpacity(0.9),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: safeAreaHeight * 0.08),
          child: nText(
            "周囲のデバイスとの接続を\n開始しますか？",
            color: Colors.white,
            fontSize: safeAreaWidth / 15,
            bold: 700,
          ),
        ),
        Container(
          height: safeAreaHeight * 0.43,
          width: safeAreaWidth * 0.9,
          decoration: BoxDecoration(
            color: blackColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(safeAreaWidth * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      textWidget("端末の設定からローカルネットワークを\n「 "),
                      textWidget("ON"),
                      textWidget(" 」にしてください。"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: safeAreaHeight * 0.05,
                    top: safeAreaHeight * 0.03,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: safeAreaHeight * 0.12,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: safeAreaHeight * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: safeAreaWidth * 0.02,
                              right: safeAreaWidth * 0.02,
                            ),
                            child: Container(
                              height: safeAreaHeight * 0.06,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/img/setting.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            alignment: Alignment.center,
                            width: safeAreaHeight * 0.11,
                            height: safeAreaHeight * 0.11,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: blueColor2,
                                  blurRadius: 20,
                                  spreadRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Container(
                              height: safeAreaHeight * 0.09,
                              width: safeAreaHeight * 0.09,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage("assets/img/switch.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                miniButton(
                  context: context,
                  text: "設定画面へ",
                  onTap: () => openAppSettings(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: safeAreaHeight * 0.1),
          child: shadowButton(context, text: "開始", onTap: onTap),
        ),
      ],
    ),
  );
}
