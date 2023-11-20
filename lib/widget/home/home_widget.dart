import 'dart:ui';
import 'dart:ui' as ui;

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
        color: text == "許可" ? greenColor : Colors.grey,
        fontSize: safeAreaWidth / 35,
      ),
    );
  }

  return BackdropFilter(
    filter: ui.ImageFilter.blur(
      sigmaX: 80.0,
      sigmaY: 80.0,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: safeAreaHeight * 0.05),
            child: nText(
              "周囲のデバイスとの接続を\n開始しますか？",
              color: Colors.white,
              fontSize: safeAreaWidth / 15,
              bold: 700,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(safeAreaWidth * 0.03),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        textWidget("端末の設定からローカルネットワークを\n「 "),
                        textWidget("許可"),
                        textWidget(" 」してください。"),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: safeAreaHeight * 0.1,
                    width: safeAreaWidth * 0.7,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: safeAreaHeight * 0.05,
                          width: safeAreaWidth * 0.65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: safeAreaWidth * 0.03,
                              right: safeAreaWidth * 0.03,
                            ),
                            child: Container(
                              height: safeAreaHeight * 0.05,
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
                          child: Padding(
                            padding:
                                EdgeInsets.only(right: safeAreaWidth * 0.04),
                            child: Container(
                              alignment: Alignment.center,
                              width: safeAreaHeight * 0.065,
                              height: safeAreaHeight * 0.065,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: blueColor2.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 1.0,
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
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: const Color.fromARGB(255, 91, 91, 91),
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () => openAppSettings(),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        alignment: Alignment.center,
                        height: safeAreaHeight * 0.04,
                        width: safeAreaWidth * 0.4,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: nText(
                          "設定画面へ",
                          color: Colors.white,
                          fontSize: safeAreaWidth / 35,
                          bold: 400,
                        ),
                      ),
                    ),
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
    ),
  );
}
