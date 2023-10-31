import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/swiper.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/widget/home/home_story_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoryAllPage extends HookConsumerWidget {
  const StoryAllPage({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final storyList = ref.watch(storyListNotifierProvider);
    final deviceList = ref.watch(deviseListNotifierProvider);
    final storyListWhen = storyList.when(
      data: (value) {
        final setData = sortUserData(value, deviceList);
        return Align(
          alignment: Alignment.topCenter,
          child: setData.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                    top: safeAreaHeight * 0.05,
                  ),
                  child: nText(
                    "過去24時間以内に出会った人がいません。",
                    color: Colors.grey,
                    fontSize: safeAreaWidth / 25,
                    bold: 700,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: safeAreaHeight * 0.05,
                          bottom: safeAreaHeight * 0.05,
                        ),
                        child: nText(
                          "過去24時間以内に\n2人のユーザーと出会いました！",
                          color: blueColor,
                          fontSize: safeAreaWidth / 22,
                          bold: 700,
                        ),
                      ),
                      for (int a = 0; a < setData.length; a = a + 3) ...{
                        Padding(
                          padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < 3; i++) ...{
                                if ((i + a) < setData.length) ...{
                                  OnStory(
                                    // key: ValueKey(" ${deviceList.value[i]} $i"),
                                    userData: setData[i + a],
                                    isMyData: false,
                                    isImgOnly: false,
                                    isNearby:
                                        deviceList.contains(setData[i + a].id),
                                    onTap: () => screenTransitionHero(
                                      context,
                                      SwiperPage(
                                        myUserData: userData,
                                        isMyData: false,
                                        index: i + a,
                                        storyList: setData,
                                      ),
                                    ),
                                  ),
                                } else ...{
                                  Opacity(
                                    opacity: 0,
                                    child: OnStory(
                                      // key: ValueKey(" ${deviceList.value[i]} $i"),
                                      userData: userData,
                                      isImgOnly: false,
                                      isMyData: false,
                                      isNearby: false,
                                      onTap: () {},
                                    ),
                                  ),
                                },
                              },
                            ],
                          ),
                        ),
                      },
                    ],
                  ),
                ),
        );
      },
      error: (e, s) => Padding(
        padding: EdgeInsets.only(bottom: safeAreaHeight * 0.1),
        child: Center(child: storyErrorWidget(context)),
      ),
      loading: () => Padding(
        padding: EdgeInsets.only(top: safeAreaHeight * 0.1),
        child: storyLoadingWidget(
          context,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: blackColor,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: nText(
          "過去24時間の履歴",
          color: Colors.white,
          fontSize: safeAreaWidth / 24,
          bold: 700,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            height: 0.5,
            color: Colors.grey,
            alignment: Alignment.center,
          ),
        ),
      ),
      body: storyListWhen,
    );
  }
}

List<UserData> sortUserData(List<UserData> data, List<String> idList) {
  final List<UserData> list1 = [];
  final List<UserData> list2 = [];
  final List<UserData> list3 = [];
  final List<UserData> list4 = [];

  for (final user in data) {
    if (idList.contains(user.id) && !user.isView) {
      list1.add(user);
    } else if (idList.contains(user.id) && user.isView) {
      list2.add(user);
    } else if (!idList.contains(user.id) && !user.isView) {
      list3.add(user);
    } else if (!idList.contains(user.id) && user.isView) {
      list4.add(user);
    }
  }
  return [...list1, ...list2, ...list3, ...list4];
}
