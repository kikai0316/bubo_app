import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/nearby_list.dart';
import 'package:bubu_app/widget/home/home_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessagePage extends HookConsumerWidget {
  const MessagePage({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final messageList = ref.watch(messageListNotifierProvider);
    final nearbyList = ref.watch(nearbyUsersNotifierProvider);
    final messageListWhen = messageList.when(
      data: (value) {
        final setData =
            sortMessageListsByDateAndId(value, nearbyList?.data ?? []);
        if (setData.isEmpty) {
          return Center(
            child: nText(
              "メッセージはありません。",
              color: Colors.white.withOpacity(0.5),
              fontSize: safeAreaWidth / 25,
              bold: 700,
            ),
          );
        } else {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: safeAreaHeight * 0.01,
                ),
                for (int i = 0; i < setData.length; i++) ...{
                  OnMessage(
                    messageData: setData[i],
                    myData: userData,
                    isNearby: (nearbyList?.data ?? [])
                        .contains(setData[i].userData.id),
                  ),
                },
              ],
            ),
          );
        }
      },
      loading: () => messageLoading(context),
      error: (e, s) => const SizedBox(),
    );

    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: nText(
          "トーク",
          color: Colors.white,
          fontSize: safeAreaWidth / 17,
          bold: 700,
        ),
      ),
      body: SafeArea(child: messageListWhen),
    );
  }
}

List<MessageList> sortMessageListsByDateAndId(
  List<MessageList> messageLists,
  List<String> idList,
) {
  final List<MessageList> sortedLists = List.from(messageLists);
  sortedLists.sort((a, b) {
    final DateTime dateA = a.message.last.dateTime;
    final DateTime dateB = b.message.last.dateTime;
    return dateB.compareTo(dateA);
  });
  final List<MessageList> prioritizedLists = [];
  final List<MessageList> otherLists = [];
  for (final messageList in sortedLists) {
    if (idList.contains(messageList.userData.id)) {
      prioritizedLists.add(messageList);
    } else {
      otherLists.add(messageList);
    }
  }
  return prioritizedLists + otherLists;
}
