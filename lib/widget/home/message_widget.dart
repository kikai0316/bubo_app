import 'dart:math';
import 'dart:ui';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/emoji.dart';
import 'package:bubu_app/constant/img.dart';
import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

Widget myChatWidget(
  BuildContext context, {
  required MessageData messeageData,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.only(
      top: safeAreaHeight * 0.01,
      bottom: safeAreaHeight * 0.01,
      left: safeAreaWidth * 0.04,
      right: safeAreaWidth * 0.04,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: safeAreaWidth * 0.01),
          child: nText(
            DateFormat('HH:mm').format(messeageData.dateTime),
            color: Colors.white,
            fontSize: safeAreaWidth / 40,
            bold: 700,
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: safeAreaWidth * 0.7),
          decoration: BoxDecoration(
            color: blueColor2,
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(safeAreaWidth * 0.03),
            child: nText(
              messeageData.message,
              color: Colors.white,
              fontSize: safeAreaWidth / 30,
              bold: 700,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget recipientChatWidget(
  BuildContext context, {
  required MessageData messeageData,
  required UserData userData,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.only(
      top: safeAreaHeight * 0.01,
      bottom: safeAreaHeight * 0.01,
      left: safeAreaWidth * 0.03,
      right: safeAreaWidth * 0.03,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: safeAreaWidth * 0.03),
          child: Container(
            width: safeAreaHeight * 0.04,
            height: safeAreaHeight * 0.04,
            decoration: BoxDecoration(
              image: userData.imgList.isEmpty
                  ? notImg()
                  : DecorationImage(
                      image: MemoryImage(userData.imgList.first),
                      fit: BoxFit.cover,
                    ),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: safeAreaWidth * 0.6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.8),
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(safeAreaWidth * 0.03),
                  child: nText(
                    messeageData.message,
                    color: Colors.white,
                    fontSize: safeAreaWidth / 30,
                    bold: 700,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: safeAreaWidth * 0.01),
                child: nText(
                  DateFormat('HH:mm').format(messeageData.dateTime),
                  color: Colors.white,
                  fontSize: safeAreaWidth / 40,
                  bold: 700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget emojiChatWidget(
  BuildContext context, {
  required MessageData messeageData,
  required UserData userData,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final String? emoji = emojiData[messeageData.message];
  final isMyData = messeageData.isMyMessage;
  return emoji == null
      ? const SizedBox()
      : Padding(
          padding: EdgeInsets.only(
            top: safeAreaHeight * 0.01,
            bottom: safeAreaHeight * 0.01,
            left: safeAreaWidth * 0.03,
            right: safeAreaWidth * 0.03,
          ),
          child: isMyData
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: safeAreaWidth * 0.01,
                      ),
                      child: nText(
                        DateFormat('HH:mm').format(messeageData.dateTime),
                        color: Colors.white,
                        fontSize: safeAreaWidth / 40,
                        bold: 700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: safeAreaWidth * 0.03,
                        right: safeAreaWidth * 0.05,
                      ),
                      child: Text(
                        emoji,
                        style: TextStyle(
                          fontSize: safeAreaWidth / 7,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: safeAreaWidth * 0.05),
                      child: Container(
                        width: safeAreaHeight * 0.04,
                        height: safeAreaHeight * 0.04,
                        decoration: userData.imgList.isEmpty
                            ? null
                            : BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(userData.imgList.first),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                              ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: safeAreaWidth * 0.03,
                              right: safeAreaWidth * 0.03,
                            ),
                            child: Text(
                              emoji,
                              style: TextStyle(
                                fontSize: safeAreaWidth / 7,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: safeAreaWidth * 0.01,
                            ),
                            child: nText(
                              DateFormat('HH:mm').format(messeageData.dateTime),
                              color: Colors.white,
                              fontSize: safeAreaWidth / 40,
                              bold: 700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
}

Widget textFieldWidget({
  required BuildContext context,
  required TextEditingController? controller,
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: [
          blackColor.withOpacity(0),
          blackColor.withOpacity(1),
          blackColor.withOpacity(1),
        ],
      ),
    ),
    child: Padding(
      padding: EdgeInsets.only(
        top: safeAreaHeight * 0.01,
        bottom: safeAreaHeight * 0.01,
        left: safeAreaWidth * 0.03,
        right: safeAreaWidth * 0.03,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: safeAreaHeight * 0.15,
        ),
        width: safeAreaWidth * 0.95,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: safeAreaWidth * 0.05,
                  right: safeAreaWidth * 0.03,
                ),
                child: TextFormField(
                  controller: controller,
                  maxLines: null,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Normal",
                    fontVariations: const [FontVariation("wght", 700)],
                    color: Colors.white,
                    fontSize: safeAreaWidth / 25,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "メッセージを入力...",
                    hintStyle: TextStyle(
                      fontFamily: "Normal",
                      color: Colors.grey,
                      fontVariations: const [FontVariation("wght", 600)],
                      fontSize: safeAreaWidth / 25,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: safeAreaHeight * 0.005,
                bottom: safeAreaHeight * 0.005,
                right: safeAreaHeight * 0.005,
              ),
              child: Material(
                color: blueColor2,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    width: safeAreaWidth * 0.15,
                    height: safeAreaHeight * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: safeAreaWidth * 0.01,
                      ),
                      child: Transform.rotate(
                        angle: -15 * 2.0 * pi / 180,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: safeAreaWidth / 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String formatDateLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  if (date.isAtSameMomentAs(today)) {
    return '今日';
  } else if (date.isAtSameMomentAs(yesterday)) {
    return '昨日';
  } else {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

Widget dateLabelWidget(BuildContext context, DateTime date) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(
      top: safeAreaHeight * 0.03,
      bottom: safeAreaHeight * 0.02,
    ),
    child: Container(
      padding: const EdgeInsets.all(5.0),
      width: safeAreaWidth * 0.25,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: nText(
        formatDateLabel(date),
        color: Colors.white.withOpacity(0.3),
        fontSize: safeAreaWidth / 30,
        bold: 700,
      ),
    ),
  );
}

class MainImgWidget extends HookConsumerWidget {
  const MainImgWidget({
    super.key,
    required this.userData,
    required this.myUserData,
  });
  final UserData userData;
  final UserData myUserData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTapEvent = useState<bool>(false);
    final safeAreaHeight = safeHeight(context);
    return GestureDetector(
      onTap: () {
        isTapEvent.value = false;
        Navigator.push<Widget>(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => SwiperPage(
              isMyData: false,
              index: 0,
              storyList: [userData],
              myUserData: myUserData,
            ),
          ),
        );
      },
      onTapDown: (TapDownDetails downDetails) {
        isTapEvent.value = true;
      },
      onTapCancel: () {
        isTapEvent.value = false;
      },
      child: Hero(
        tag: userData.id,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: userData.isView ? Colors.grey.withOpacity(0.5) : null,
            gradient: userData.isView
                ? null
                : const LinearGradient(
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 4, 15, 238),
                      Color.fromARGB(255, 6, 120, 255),
                      Color.fromARGB(255, 4, 200, 255),
                    ],
                  ),
          ),
          child: Padding(
            padding: EdgeInsets.all(safeAreaHeight * 0.0035),
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: blackColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(safeAreaHeight * 0.004),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: userData.imgList.isEmpty
                        ? null
                        : DecorationImage(
                            image: MemoryImage(
                              userData.imgList.first,
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
