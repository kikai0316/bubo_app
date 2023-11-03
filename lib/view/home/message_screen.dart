import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/widget/home/home_message_widget.dart';
import 'package:bubu_app/widget/home/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageScreenPage extends HookConsumerWidget {
  MessageScreenPage({
    super.key,
    required this.messageUserData,
    required this.myData,
  });
  final UserData messageUserData;
  final UserData myData;
  final TextEditingController controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final deviceList = ref.watch(deviseListNotifierProvider);
    final isLoading = useState(false);
    final setDeviceList = (deviceList ?? [])
        .map((element) => element.deviceId.split('@')[0])
        .toList();
    final messageList = ref.watch(messageListNotifierProvider);
    final messageListWhen = messageList.when(
      data: (value) {
        final List<MessageList> getData = value
            .where(
              (messageList) => messageList.userData.id == messageUserData.id,
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
          return Scaffold(
            backgroundColor: blackColor,
            appBar: appber(
              context,
              userData: getData.first.userData,
              isNearby: setDeviceList.contains(messageUserData.id),
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
                          final date = getData.first.message[newIndex].dateTime;
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
                              if (getData
                                  .first.message[newIndex].isMyMessage) ...{
                                myChatWidget(
                                  context,
                                  messeageData: getData.first.message[newIndex],
                                ),
                              } else ...{
                                recipientChatWidget(
                                  context,
                                  messeageData: getData.first.message[newIndex],
                                  userData: getData.first.userData,
                                ),
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
                    child: setDeviceList.contains(messageUserData.id)
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: safeAreaHeight * 0.001,
                            ),
                            child: textFieldWidget(
                              context: context,
                              controller: controller,
                              onTap: () async {
                                if (setDeviceList
                                    .contains(messageUserData.id)) {
                                  if (controller.text.isNotEmpty) {
                                    isLoading.value = true;
                                    final notifier = ref.read(
                                      deviseListNotifierProvider.notifier,
                                    );
                                    final isSend = await notifier.sendMessage(
                                      message: controller.text,
                                      userData: messageUserData,
                                      myData: myData,
                                    );
                                    isLoading.value = false;
                                    if (!isSend) {
                                      // ignore: use_build_context_synchronously
                                      errorSnackbar(
                                        context,
                                        text: "メッセージの送信に失敗しました。",
                                        padding: safeAreaHeight * 0.08,
                                      );
                                    }
                                    controller.clear();
                                  } else {
                                    errorSnackbar(
                                      context,
                                      text: "空白のメッセージは送信できません。",
                                      padding: safeAreaHeight * 0.08,
                                    );
                                  }
                                } else {
                                  controller.clear();
                                  errorSnackbar(
                                    context,
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
        }
      },
      loading: () => Scaffold(
        backgroundColor: blackColor,
        appBar: appber(
          context,
          userData: messageUserData,
          isNearby: setDeviceList.contains(messageUserData.id),
        ),
        body: messageLoading(context),
      ),
      error: (e, s) => Scaffold(
        backgroundColor: blackColor,
        appBar: appber(
          context,
          userData: messageUserData,
          isNearby: setDeviceList.contains(messageUserData.id),
        ),
        body: messageError(
          context,
          MessageScreenPage(
            messageUserData: messageUserData,
            myData: myData,
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
                    child: SizedBox(
                      width: safeAreaHeight * 0.065,
                      height: safeAreaHeight * 0.065,
                      child: MainImgWidget(
                        userData: userData,
                        myUserData: myData,
                      ),
                    ),
                  ),
                  nText(
                    userData.name,
                    color: Colors.white,
                    fontSize: safeAreaWidth / 23,
                    bold: 700,
                  ),
                ],
              ),
              Container(
                width: safeAreaHeight * 0.055,
                height: safeAreaHeight * 0.055,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img/Instagram.png"),
                    fit: BoxFit.cover,
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
