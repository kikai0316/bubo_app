import 'package:bubu_app/component/component.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/story_all_page.dart';
import 'package:bubu_app/view/home/swiper.dart';
import 'package:bubu_app/view/user_app.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/widget/home/home_message_widget.dart';
import 'package:bubu_app/widget/home/home_story_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final storyList = ref.watch(storyListNotifierProvider);
    final messageList = ref.watch(messageListNotifierProvider);
    final deviceList = ref.watch(deviseListNotifierProvider);
    final setDeviceList = (deviceList ?? [])
        .map((element) => element.deviceId.split('@')[0])
        .toList();
    final storyListWhen = storyList.when(
      data: (value) {
        final setData = sortStoryList(value, setDeviceList);
        return Column(
          children: [
            Align(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: safeAreaHeight * 0.01,
                ),
                child: Padding(
                  padding: EdgeInsets.all(safeAreaHeight * 0.02),
                  child: nText(
                    setData.isEmpty
                        ? "付近にユーザーは存在しません"
                        : "付近に${setData.length}人のユーザーがいます",
                    color: Colors.grey.withOpacity(0.7),
                    fontSize: safeAreaWidth / 35,
                    bold: 700,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: safeAreaWidth * 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: safeAreaWidth * 0.02,
                    ),
                    for (int i = 0; i < setData.length + 1; i++) ...{
                      OnStory(
                        isImgOnly: false,
                        userData: i == 0 ? userData : setData[i - 1],
                        isMyData: i == 0,
                        isNearby: true,
                        onTap: () => screenTransitionHero(
                          context,
                          SwiperPage(
                            myUserData: userData,
                            isMyData: i == 0,
                            index: i == 0 ? 0 : i - 1,
                            storyList: i == 0 ? [userData] : setData,
                          ),
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ),
          ],
        );
      },
      error: (e, s) => storyErrorWidget(
        context,
      ),
      loading: () => storyLoadingWidget(
        context,
      ),
    );
    final messageListWhen = messageList.when(
      data: (value) {
        final setData = sortMessageListsByDate(value);
        if (setData.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.2),
              child: nText(
                "メッセージはありません。",
                color: Colors.white.withOpacity(0.5),
                fontSize: safeAreaWidth / 25,
                bold: 700,
              ),
            ),
          );
        } else {
          return Column(
            children: [
              for (int i = 0; i < setData.length; i++) ...{
                OnMessage(
                  messageData: setData[i],
                  myData: userData,
                ),
              },
            ],
          );
        }
      },
      loading: () => messageLoading(context),
      error: (e, s) => messageError(
        context,
        const UserApp(
          initPage: 0,
        ),
      ),
    );

    useEffect(
      () {
        if (deviceList == null) {
          final notifier = ref.read(deviseListNotifierProvider.notifier);
          notifier.initNearbyService(userData);
        }
        return null;
      },
      [deviceList],
    );

    return Material(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: blackColor,
        appBar: appberWithLogo(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              storyListWhen,
              line(
                context,
                top: safeAreaHeight * 0.015,
                bottom: 0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: safeAreaWidth * 0.03,
                  top: safeAreaHeight * 0.015,
                  bottom: safeAreaHeight * 0.01,
                ),
                child: nText(
                  "メッセージ",
                  color: Colors.white,
                  fontSize: safeAreaWidth / 22,
                  bold: 700,
                ),
              ),
              messageListWhen,
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: safeAreaHeight * 0.1),
          child: FloatingActionButton(
            backgroundColor: blueColor,
            onPressed: () => screenTransitionNormal(
              context,
              const StoryAllPage(),
            ),
            child: Icon(
              Icons.history,
              color: Colors.white,
              size: safeAreaWidth / 13,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appberWithLogo(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size.fromHeight(safeAreaHeight * 0.05),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: safeAreaHeight * 0.1,
              width: safeAreaWidth * 0.22,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/logo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Icon(
            //       Icons.history,
            //       size: safeAreaWidth / 11,
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

List<MessageList> sortMessageListsByDate(List<MessageList> messageLists) {
  final List<MessageList> sortedLists = List.from(messageLists);
  sortedLists.sort((a, b) {
    final DateTime dateA = a.message.last.dateTime;
    final DateTime dateB = b.message.last.dateTime;
    return dateB.compareTo(dateA);
  });
  return sortedLists;
}

List<UserData> sortStoryList(List<UserData> data, List<String> idList) {
  final List<UserData> list1 = [];
  final List<UserData> list2 = [];

  for (final user in data) {
    if (idList.contains(user.id)) {
      if (!user.isView) {
        list1.add(user);
      } else {
        list2.add(user);
      }
    }
  }
  return [...list1, ...list2];
}
