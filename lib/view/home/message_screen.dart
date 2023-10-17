import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/widget/home/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageScreenPage extends HookConsumerWidget {
  MessageScreenPage({
    super.key,
    required this.recipientData,
    required this.myData,
  });
  final UserData recipientData;
  final UserData myData;
  final TextEditingController controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    // final safeAreaWidth = MediaQuery.of(context).size.width;
    // final base64String = base64Encode(myData.imgList.first);
    final sss = MessageData(
      userId: "${recipientData.id}111",
      message: "ここここここここっここここここっこここおこここここここ",
      isRead: false,
      dateTime: DateTime.now(),
    );
    final s1 = MessageData(
      userId: recipientData.id,
      message: "ここここここここっここここここっこここおこここここここ",
      isRead: false,
      dateTime: DateTime.now(),
    );
    final messageList = useState<List<MessageData>>([sss, s1]);
    return Scaffold(
      backgroundColor: blackColor,
      appBar: appber(context, recipientData),
      body: Stack(
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                  itemCount: messageList.value.length,
                  shrinkWrap: true,
                  reverse: true,
                  padding: EdgeInsets.only(
                    top: safeAreaHeight * 0.01,
                    bottom: safeAreaHeight * (focusNode.hasFocus ? 0.18 : 0.1),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final newIndex = messageList.value.length - index - 1;

                    if (myData.id == messageList.value[newIndex].userId) {
                      return myChatWidget(
                        context,
                        messeageText: messageList.value[newIndex].message,
                        dateTime: messageList.value[newIndex].dateTime,
                      );
                    } else {
                      return recipientChatWidget(
                        context,
                        messeageText: messageList.value[newIndex].message,
                        img: recipientData.imgList.first,
                        dateTime: messageList.value[newIndex].dateTime,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: safeAreaHeight * 0.001,
                ),
                child: textFieldWidget(
                  context: context,
                  controller: controller,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget appber(BuildContext context, UserData userData) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(safeAreaHeight * 0.09),
      child: AppBar(
        backgroundColor: blackColor,
        elevation: 10,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            height: 0.2,
            color: Colors.grey,
          ),
        ),
        title: SizedBox(
          height: safeAreaHeight * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: safeAreaHeight * 0.05,
                height: safeAreaHeight * 0.05,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(userData.imgList.first),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              nText(
                userData.name,
                color: Colors.white,
                fontSize: safeAreaWidth / 30,
                bold: 700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
