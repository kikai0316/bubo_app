import 'dart:ui';

import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/account/profile_setting.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingTitle = ["バージョン", "利用規約", "プライバシーポリシー", "アカウント削除"];

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

class AccountMain extends HookConsumerWidget {
  const AccountMain({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final notifier = ref.watch(storyListNotifierProvider);
    final int? notifierWhen = notifier.when(
      data: (data) => countDataForToday(data),
      error: (e, s) => null,
      loading: () => null,
    );

    return Container(
      width: safeAreaWidth * 0.9,
      decoration: BoxDecoration(
        color: blackColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: safeAreaWidth * 0.07,
          left: safeAreaWidth * 0.05,
          right: safeAreaWidth * 0.05,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: safeAreaHeight * 0.01),
              child: Container(
                height: safeAreaHeight * 0.11,
                width: safeAreaHeight * 0.11,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: MemoryImage(
                      userData.imgList.first,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: nText(
                  userData.name,
                  color: Colors.white,
                  fontSize: safeAreaWidth / 20,
                  bold: 700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < 2; i++) ...{
                    SizedBox(
                      width: safeAreaWidth * 0.4,
                      child: Column(
                        children: [
                          nText(
                            i == 0 ? "1,000" : notifierWhen?.toString() ?? "-",
                            color: Colors.white,
                            fontSize: safeAreaWidth / 20,
                            bold: 700,
                          ),
                          nText(
                            i == 0 ? "これまでに出会った人数" : "今日出会った人数",
                            color: Colors.grey,
                            fontSize: safeAreaWidth / 40,
                            bold: 400,
                          ),
                        ],
                      ),
                    ),
                  },
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: safeAreaWidth * 0.06,
                bottom: safeAreaWidth * 0.05,
              ),
              child: customButton(
                context: context,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                text: "基本情報設定",
                textSize: safeAreaWidth / 30,
                height: safeAreaHeight * 0.06,
                width: safeAreaWidth * 1,
                onTap: () => screenTransitionNormal(
                  context,
                  ProfileSetting(
                    userData: userData,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int countDataForToday(List<UserData> data) {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59);
    int count = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].acquisitionAt != null &&
          data[i].acquisitionAt!.isAfter(startOfDay) &&
          data[i].acquisitionAt!.isBefore(endOfDay)) {
        count++;
      }
    }
    return count;
  }
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
