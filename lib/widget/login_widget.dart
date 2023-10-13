import 'dart:ui';

import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget upWidget(BuildContext context, {required void Function()? onTap}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    borderRadius: BorderRadius.circular(10),
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.topCenter,
        height: safeAreaHeight * 0.2,
        width: safeAreaWidth * 0.25,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: safeAreaWidth / 18,
            ),
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
              child: Text(
                textAlign: TextAlign.center,
                "画像・写真を\nアップロードする",
                style: TextStyle(
                  fontSize: safeAreaWidth / 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget imgWidget(
  BuildContext context, {
  required void Function()? onTap,
  required Uint8List img,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(left: safeAreaWidth * 0.05),
    child: Container(
      alignment: Alignment.bottomRight,
      height: safeAreaHeight * 0.2,
      width: safeAreaWidth * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: MemoryImage(img),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(safeAreaWidth * 0.01),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            height: safeAreaHeight * 0.04,
            width: safeAreaHeight * 0.04,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: safeAreaWidth / 18,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget privacyText({
  required BuildContext context,
  required void Function()? onTap1,
  required void Function()? onTap2,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  InlineSpan textWidget(
    String text, {
    required bool isBlue,
    required GestureRecognizer? onTap,
  }) {
    return TextSpan(
      text: text,
      recognizer: onTap,
      style: TextStyle(
        fontFamily: "Normal",
        fontVariations: const [FontVariation("wght", 400)],
        color: isBlue ? blueColor : Colors.white,
        fontSize: safeAreaWidth / 35,
        decoration: isBlue ? TextDecoration.underline : null,
      ),
    );
  }

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        textWidget('ログインすると、あなたは当アプリの', isBlue: false, onTap: null),
        textWidget(
          '利用規約',
          isBlue: true,
          onTap: TapGestureRecognizer()..onTap = onTap1,
        ),
        textWidget(
          'に同意することになります。当社における個人情報の取り扱いについては、',
          isBlue: false,
          onTap: null,
        ),
        textWidget(
          'プライバシーポリシー',
          isBlue: true,
          onTap: TapGestureRecognizer()..onTap = onTap2,
        ),
        textWidget('をご覧ください。', isBlue: false, onTap: null),
      ],
    ),
  );
}
