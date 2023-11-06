import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/emoji.dart';
import 'package:bubu_app/constant/img.dart';
import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:bubu_app/widget/home/home_message_widget.dart';
import 'package:bubu_app/widget/home/message_widget.dart';
import 'package:bubu_app/widget/home/swiper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final deviceList = ref.watch(deviseListNotifierProvider);
    final isLoading = useState(false);
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
    final setDeviceList = (deviceList ?? [])
        .map((element) => element.deviceId.split('@')[0])
        .toList();
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
                final getImg = await imgMainGet(getData.first.userData);
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
                myUserData: myUserNotifireWhen,
                userData: getData.first.userData,
                isNearby: setDeviceList.contains(id),
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: ListView.builder(
                          itemCount: getData.first.message.length,
                          shrinkWrap: true,
                          reverse: true,
                          padding: EdgeInsets.only(
                            top: safeAreaHeight * 0.01,
                            bottom: safeAreaHeight *
                                (focusNode.hasFocus ? 0.18 : 0.1),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final newIndex =
                                getData.first.message.length - index - 1;
                            final date =
                                getData.first.message[newIndex].dateTime;
                            final lastDate = newIndex - 1 > -1
                                ? getData.first.message[newIndex - 1].dateTime
                                : null;
                            final bool isNewDay = lastDate?.day == date.day &&
                                lastDate?.month == date.month &&
                                lastDate?.year == date.year;
                            return Column(
                              children: [
                                if (!isNewDay) ...{
                                  dateLabelWidget(context, date),
                                },
                                if (emojiData.containsKey(
                                  getData.first.message[newIndex].message,
                                )) ...{
                                  emojiChatWidget(
                                    context,
                                    messeageData:
                                        getData.first.message[newIndex],
                                    userData: getData.first.userData,
                                  ),
                                } else ...{
                                  if (getData
                                      .first.message[newIndex].isMyMessage) ...{
                                    myChatWidget(
                                      context,
                                      messeageData:
                                          getData.first.message[newIndex],
                                    ),
                                  } else ...{
                                    recipientChatWidget(
                                      context,
                                      messeageData:
                                          getData.first.message[newIndex],
                                      userData: getData.first.userData,
                                    ),
                                  },
                                },
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: setDeviceList.contains(id)
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: safeAreaHeight * 0.001,
                              ),
                              child: textFieldWidget(
                                context: context,
                                controller: controller,
                                onTap: () async {
                                  if (setDeviceList.contains(id)) {
                                    if (controller.text.isNotEmpty) {
                                      isLoading.value = true;
                                      final notifier = ref.read(
                                        deviseListNotifierProvider.notifier,
                                      );
                                      final isSend = await notifier.sendMessage(
                                        message: controller.text,
                                        userData: messageUserDataNotifireWhen
                                            .userData,
                                        myData: myUserNotifireWhen,
                                      );
                                      isLoading.value = false;
                                      if (!isSend) {
                                        // ignore: use_build_context_synchronously
                                        errorSnackbar(
                                          text: "メッセージの送信に失敗しました。",
                                          padding: safeAreaHeight * 0.08,
                                        );
                                      }
                                      controller.clear();
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
                          : nText(
                              "相手が通信範囲外です",
                              color: Colors.white,
                              fontSize: safeAreaWidth / 25,
                              bold: 700,
                            ),
                    ),
                  ),
                  loadinPage(
                    context: context,
                    isLoading: isLoading.value,
                    text: "接続中...",
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

    return SizedBox(
      child: messageListWhen,
    );
  }

  PreferredSizeWidget appber(
    BuildContext context, {
    required UserData userData,
    required UserData myUserData,
    required bool isNearby,
  }) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
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
                    child: Container(
                      width: safeAreaHeight * 0.065,
                      height: safeAreaHeight * 0.065,
                      decoration: BoxDecoration(
                        image: userData.imgList.isEmpty ? notImg() : null,
                        shape: BoxShape.circle,
                      ),
                      child: userData.imgList.isNotEmpty
                          ? MainImgWidget(
                              userData: userData,
                              myUserData: myUserData,
                            )
                          : null,
                    ),
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
            isRead: true,
          ),
        )
        .toList(),
  );
}
