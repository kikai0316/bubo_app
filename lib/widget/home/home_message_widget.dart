import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/message_screen.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnMessage extends HookConsumerWidget {
  const OnMessage({super.key, required this.messageData, required this.myData});
  final MessageList messageData;
  final UserData myData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    useEffect(
      () {
        var cancelled = false;
        Future(() async {
          if (messageData.userData.imgList.isEmpty) {
            final getData = await imgMainGet(messageData.userData);
            if (cancelled) return;
            if (getData != null) {
              final notifier = ref.read(messageListNotifierProvider.notifier);
              notifier.mainImgUpDate(getData, messageData);
            }
          }
        });

        return () {
          cancelled = true;
        };
      },
      [],
    );
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () => Navigator.push<Widget>(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreenPage(
              myData: myData,
              messageUserData: messageData.userData,
            ),
          ),
        ),
        child: Container(
          width: double.infinity,
          color: Colors.black.withOpacity(0),
          child: Padding(
            padding: EdgeInsets.only(
              top: safeAreaHeight * 0.015,
              left: safeAreaWidth * 0.03,
              right: safeAreaWidth * 0.03,
              bottom: safeAreaHeight * 0.015,
            ),
            child: SizedBox(
              height: safeAreaHeight * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: safeAreaWidth * 0.05),
                    child: Container(
                      height: safeAreaHeight * 0.08,
                      width: safeAreaHeight * 0.08,
                      decoration: BoxDecoration(
                        color: blackColor,
                        image: messageData.userData.imgList.isNotEmpty
                            ? DecorationImage(
                                image: MemoryImage(
                                  messageData.userData.imgList.first,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        nText(
                          messageData.userData.name,
                          color: Colors.white,
                          fontSize: safeAreaWidth / 27,
                          bold: 700,
                        ),
                        nText(
                          messageData
                              .message[messageData.message.length - 1].message,
                          color: Colors.grey,
                          fontSize: safeAreaWidth / 30,
                          bold: 500,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.08,
                    width: safeAreaWidth * 0.15,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.cen,
                      children: [
                        nText(
                          formatDate(
                            messageData.message[messageData.message.length - 1]
                                .dateTime,
                          ),
                          color: Colors.grey,
                          fontSize: safeAreaWidth / 35,
                          bold: 700,
                        ),
                        if (countUnreadMessages(messageData.message) > 0)
                          Padding(
                            padding:
                                EdgeInsets.only(top: safeAreaHeight * 0.01),
                            child: Container(
                              alignment: Alignment.center,
                              height: safeAreaHeight * 0.037,
                              width: safeAreaHeight * 0.037,
                              decoration: const BoxDecoration(
                                color: blueColor2,
                                shape: BoxShape.circle,
                              ),
                              child: nText(
                                countUnreadMessages(messageData.message)
                                    .toString(),
                                color: Colors.white,
                                fontSize: safeAreaWidth / 28,
                                bold: 700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

int countUnreadMessages(List<MessageData> messages) {
  return messages.where((message) => !message.isRead).length;
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inSeconds < 60) {
    return 'たった今';
  } else if (difference.inMinutes < 10) {
    return '${difference.inMinutes}分前';
  } else if (difference.inMinutes < 60) {
    return '${(difference.inMinutes ~/ 5) * 5}分前';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}時間前';
  } else if (difference.inDays == 1) {
    return '昨日';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}日前';
  } else if (difference.inDays < 30) {
    return '${difference.inDays ~/ 7}週間前';
  } else {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

Widget messageError(BuildContext context, Widget page) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return Padding(
    padding: EdgeInsets.only(top: safeAreaHeight * 0.05),
    child: Center(
      child: Column(
        children: [
          nText(
            "データの読み込みに失敗しました。",
            color: Colors.white,
            fontSize: safeAreaWidth / 23,
            bold: 700,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: safeAreaHeight * 0.02,
            ),
            child: customButton(
              context: context,
              height: safeAreaHeight * 0.06,
              width: safeAreaWidth * 0.4,
              text: "再試行",
              textColor: Colors.black,
              textSize: safeAreaWidth / 25,
              backgroundColor: Colors.white,
              onTap: () => screenTransition(context, page),
            ),
          ),
        ],
      ),
    ),
  );
}
