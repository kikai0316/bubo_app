import 'dart:ui';

import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final settingTitle = ["プロフィール設定", "バージョン", "利用規約", "プライバシーポリシー", "アカウント削除"];

Widget settingWidget({
  required BuildContext context,
  required String iconText,
  required Widget trailing,
  required void Function()? onTap,
  required bool isOnlyTopRadius,
  required bool isOnlyBottomRadius,
  required bool isRedTitle,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  BorderRadiusGeometry radius() {
    return BorderRadius.only(
      topLeft: isOnlyTopRadius ? const Radius.circular(20) : Radius.zero,
      topRight: isOnlyTopRadius ? const Radius.circular(20) : Radius.zero,
      bottomLeft: isOnlyBottomRadius ? const Radius.circular(20) : Radius.zero,
      bottomRight: isOnlyBottomRadius ? const Radius.circular(20) : Radius.zero,
    );
  }

  return Material(
    color: blackColor,
    borderRadius: radius(),
    child: InkWell(
      onTap: onTap,
      borderRadius: radius() as BorderRadius,
      child: SizedBox(
        height: safeAreaHeight * 0.08,
        child: Padding(
          padding: EdgeInsets.only(
            left: safeAreaWidth * 0.03,
            right: safeAreaWidth * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              nText(
                iconText,
                color: isRedTitle ? Colors.red : Colors.white,
                fontSize: safeAreaWidth / 26,
                bold: 700,
              ),
              trailing,
            ],
          ),
        ),
      ),
    ),
  );
}

Widget userNameSheet(
  BuildContext context, {
  required TextEditingController? controller,
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    height: MediaQuery.of(context).size.height / 1.5,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    child: Stack(
      children: [
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: safeAreaHeight * 0.07,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    child: Text(
                      "ユーザー名",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: safeAreaWidth / 25,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(safeAreaHeight * 0.015),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.03),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: safeAreaHeight * 0.25,
                ),
                width: safeAreaWidth * 0.9,
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 230, 230, 230).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: safeAreaWidth * 0.04,
                    right: safeAreaWidth * 0.04,
                  ),
                  child: TextFormField(
                    controller: controller,
                    autofocus: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: "Normal",
                      fontVariations: const [FontVariation("wght", 400)],
                      fontWeight: FontWeight.bold,
                      fontSize: safeAreaWidth / 30,
                    ),
                    // onChanged: onChange,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "ユーザーネームを入力...",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.3),
                        fontSize: safeAreaWidth / 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.03),
              child: bottomButton(
                context: context,
                isWhiteMainColor: false,
                text: "保存",
                onTap: onTap,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget accountMainWidget(
  BuildContext context, {
  required int data,
  required bool isEncounter,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return Container(
    width: safeAreaWidth * 0.9,
    decoration: BoxDecoration(
      color: isEncounter
          ? const Color.fromARGB(255, 85, 192, 97)
          : const Color.fromARGB(255, 0, 144, 250),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: safeAreaWidth * 0.03,
        right: safeAreaWidth * 0.03,
        top: safeAreaHeight * 0.01,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: safeAreaWidth * 0.1,
                height: safeAreaWidth * 0.1,
                decoration: BoxDecoration(
                  color: isEncounter
                      ? const Color.fromARGB(255, 136, 211, 144)
                      : const Color.fromARGB(255, 76, 177, 251),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isEncounter ? Icons.people_alt : Icons.groups,
                  color: Colors.white,
                  size: safeAreaWidth / 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: safeAreaWidth * 0.03),
                child: nText(
                  isEncounter ? "今日出会った人数" : "これまで出会った人数",
                  color: Colors.white,
                  fontSize: safeAreaWidth / 30,
                  bold: 700,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: safeAreaHeight * 0.01,
            ),
            child: Text(
              NumberFormat("#,###").format(data),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: safeAreaWidth / 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
