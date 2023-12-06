import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/emoji.dart';
import 'package:bubu_app/constant/img.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/nearby_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:bubu_app/widget/home/home_message_widget.dart';
import 'package:bubu_app/widget/home/message_widget.dart';
import 'package:bubu_app/widget/home/swiper_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageScreenPage extends HookConsumerWidget {
  MessageScreenPage({
    super.key,
    required this.id,
  });
  final String id;
  final TextEditingController controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final nearbyList = ref.watch(nearbyUsersNotifierProvider);
    final myUserNotifire = ref.watch(userDataNotifierProvider);
    final myUserNotifireWhen = myUserNotifire.when(
      data: (value) => value,
      error: (e, s) => null,
      loading: () => null,
    );
    final messageUserDataNotifire = ref.watch(messageListNotifierProvider);
    final messageUserDataNotifireWhen = messageUserDataNotifire.when(
      data: (value) => value.firstWhere(
        (data) => data.userData.id == id,
      ),
      error: (e, s) => null,
      loading: () => null,
    );

    final messageList = ref.watch(messageListNotifierProvider);

    final messageListWhen = messageList.when(
      data: (value) {
        final List<MessageList> getData = value
            .where(
              (messageList) => messageList.userData.id == id,
            )
            .toList();
        if (getData.isNotEmpty) {
          if (countUnreadMessages(getData.first.message) > 0) {
            final notifier = ref.read(messageListNotifierProvider.notifier);
            notifier.dataUpDate(
              updateAllToRead(getData.first.message, getData.first.userData),
            );
          }
          if (getData.first.userData.imgList.isEmpty) {
            Future(() async {
              if (getData.first.userData.imgList.isEmpty) {
                final getImg = await imgMainGet(getData.first.userData.id);
                if (getImg != null) {
                  if (context.mounted) {
                    final notifier =
                        ref.read(messageListNotifierProvider.notifier);
                    notifier.mainImgUpDate(getImg, getData.first);
                  }
                }
              }
            });
          }
          if (myUserNotifireWhen != null &&
              messageUserDataNotifireWhen != null) {
            return Scaffold(
              backgroundColor: blackColor,
              appBar: appber(
                context,
                ref: ref,
                myUserData: myUserNotifireWhen,
                userData: getData.first.userData,
                isNearby: (nearbyList?.data ?? []).contains(id),
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: safeAreaHeight * 0.01,
                              ),
                              for (int i = 0;
                                  i < getData.first.message.length;
                                  i++) ...{
                                talkWidget(context, getData, i),
                              },
                              SizedBox(
                                height: safeAreaHeight *
                                    (focusNode.hasFocus ? 0.18 : 0.1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: (nearbyList?.data ?? []).contains(id)
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: safeAreaHeight * 0.001,
                              ),
                              child: MessageTextFieldWidget(
                                controller: controller,
                                onTap: () async {
                                  if ((nearbyList?.data ?? []).contains(id)) {
                                    if (controller.text.isNotEmpty) {
                                      final text = controller.text;
                                      primaryFocus?.unfocus();
                                      controller.clear();
                                      final notifier = ref.read(
                                        messageListNotifierProvider.notifier,
                                      );
                                      final isSend = await notifier.sendMessage(
                                        myUserNotifireWhen.id,
                                        messageUserDataNotifireWhen.userData,
                                        text,
                                      );
                                      if (context.mounted) {
                                        if (!isSend) {
                                          errorSnackbar(
                                            text: "メッセージの送信に失敗しました。",
                                            padding: safeAreaHeight * 0.08,
                                          );
                                        }
                                      }
                                    } else {
                                      errorSnackbar(
                                        text: "空白のメッセージは送信できません。",
                                        padding: safeAreaHeight * 0.08,
                                      );
                                    }
                                  } else {
                                    controller.clear();
                                    errorSnackbar(
                                      text: "相手との距離が、通信範囲外です。",
                                      padding: safeAreaHeight * 0.08,
                                    );
                                  }
                                },
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                bottom: safeAreaHeight * 0.01,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: safeAreaHeight * 0.055,
                                width: safeAreaWidth * 0.7,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 38, 38, 38),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: nText(
                                  "相手が通信範囲外です",
                                  color: Colors.white,
                                  fontSize: safeAreaWidth / 28,
                                  bold: 700,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: blackColor,
              body: messageLoading(context),
            );
          }
        }
      },
      loading: () => Scaffold(
        backgroundColor: blackColor,
        body: messageLoading(context),
      ),
      error: (e, s) => Scaffold(
        backgroundColor: blackColor,
        body: messageError(
          context,
          MessageScreenPage(
            id: id,
          ),
        ),
      ),
    );

    return Stack(
      children: [
        SizedBox(
          child: messageListWhen,
        ),
      ],
    );
  }

  PreferredSizeWidget appber(
    BuildContext context, {
    required UserData userData,
    required UserData myUserData,
    required bool isNearby,
    required WidgetRef ref,
  }) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final storyList = ref.watch(storyListNotifierProvider);
    final List<UserData> storyNotifier = storyList.when(
      data: (data) => data,
      error: (e, s) => [],
      loading: () => [],
    );

    final int index = storyNotifier.indexWhere(
      (value) => value.id == userData.id,
    );
    Widget imgWidget() {
      if (userData.imgList.isEmpty) {
        return Container(
          width: safeAreaHeight * 0.065,
          height: safeAreaHeight * 0.065,
          decoration: BoxDecoration(
            image: userData.imgList.isEmpty ? notImg() : null,
            shape: BoxShape.circle,
          ),
        );
      } else if (!isNearby || index == -1) {
        return Container(
          width: safeAreaHeight * 0.065,
          height: safeAreaHeight * 0.065,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                userData.imgList.first,
              ),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
          ),
        );
      } else {
        return SizedBox(
          width: safeAreaHeight * 0.065,
          height: safeAreaHeight * 0.065,
          child: MainImgWidget(
            userData: storyNotifier[index],
            myUserData: myUserData,
          ),
        );
      }
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(safeAreaHeight * 0.115),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
        elevation: 10,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            height: safeAreaHeight * 0.035,
            // color: isNearby ? greenColor : Colors.grey,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                nText(
                  isNearby ? "このユーザーは、付近にいます" : "通信範囲外のため、接続が切断されました",
                  color: isNearby ? greenColor : Colors.grey,
                  fontSize: safeAreaWidth / 35,
                  bold: 700,
                ),
                Container(
                  height: 3,
                  color: isNearby ? greenColor : Colors.grey,
                ),
              ],
            ),
          ),
        ),
        title: SizedBox(
          height: safeAreaHeight * 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: safeAreaWidth / 14,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: safeAreaWidth * 0.05,
                      right: safeAreaWidth * 0.03,
                    ),
                    child: imgWidget(),
                  ),
                  nText(
                    userData.imgList.isEmpty ? "Unknown" : userData.name,
                    color: Colors.white,
                    fontSize: safeAreaWidth / 23,
                    bold: 700,
                  ),
                ],
              ),
              if (userData.imgList.isNotEmpty)
                GestureDetector(
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: InstagramGetDialog(
                        userData: userData,
                      ),
                    ),
                  ),
                  child: Container(
                    width: safeAreaHeight * 0.055,
                    height: safeAreaHeight * 0.055,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/img/Instagram.png"),
                        fit: BoxFit.cover,
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

  Widget talkWidget(
    BuildContext context,
    List<MessageList> getData,
    int index,
  ) {
    final message = getData.first.message[index];
    final date = message.dateTime;
    final bool isNewDay;
    if (index == 0) {
      isNewDay = true;
    } else {
      final prevDate = getData.first.message[index - 1].dateTime;
      isNewDay = date.day != prevDate.day ||
          date.month != prevDate.month ||
          date.year != prevDate.year;
    }

    return Column(
      children: [
        if (isNewDay) ...{
          dateLabelWidget(context, date),
        },
        if (emojiData.containsKey(message.message)) ...{
          emojiChatWidget(
            context,
            messeageData: message,
            userData: getData.first.userData,
          ),
        } else ...{
          if (message.isMyMessage) ...{
            myChatWidget(
              context,
              messeageData: message,
            ),
          } else ...{
            recipientChatWidget(
              context,
              messeageData: message,
              userData: getData.first.userData,
            ),
          },
        },
      ],
    );
  }
}

MessageList updateAllToRead(List<MessageData> messages, UserData userData) {
  return MessageList(
    userData: userData,
    message: messages
        .map(
          (message) => MessageData(
            isMyMessage: message.isMyMessage,
            message: message.message,
            dateTime: message.dateTime,
            valueKey: message.valueKey,
            isRead: true,
          ),
        )
        .toList(),
  );
}