import 'package:bubu_app/component/component.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/swiper.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/widget/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.userData});
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
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: safeAreaHeight * 0.01,
                  right: safeAreaWidth * 0.03,
                ),
                child: nText(
                  "今日すれ違った数：${value.length}人",
                  color: Colors.white,
                  fontSize: safeAreaWidth / 35,
                  bold: 500,
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
                        // key: ValueKey(" ${deviceList.value[i]} $i"),
                        userData: i == 0 ? userData : setData[i - 1],
                        isMyData: i == 0,
                        isNearby:
                            i > 0 && deviceList.contains(setData[i - 1].id),
                        index: i,
                        onTap: () {
                          Navigator.push<Widget>(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) => SwiperPage(
                                isMyData: i == 0,
                                index: i,
                                storyList: i == 0 ? [userData] : setData,
                              ),
                            ),
                          );
                        },
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

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      appBar: appberWithLogo(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          storyListWhen,
          line(
            context,
            top: safeAreaHeight * 0.01,
            bottom: safeAreaHeight * 0.01,
          ),
          // Align(
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: safeAreaHeight * 0.01),
          //     child: nText("メッセージ",
          //         color: Colors.white, fontSize: safeAreaWidth / 20, bold: 700),
          //   ),
          // ),
          for (int i = 0; i < 2; i++) ...{
            if (i != 0) ...{
              line(context, top: 0, bottom: 0),
            },
            onMessage(context, userData),
          },
          // SizedBox(
          //   height: safeAreaHeight * 0.11,
          // ),
          // for (int i = 0; i < transmissionHistory.value.length; i++) ...{
          //   Text(
          //     transmissionHistory.value[i],
          //     style: const TextStyle(color: Colors.red),
          //   )
          // },
          // bottomButton(
          //   context: context,
          //   isWhiteMainColor: true,
          //   text: "削除",
          //   onTap: () async {
          //     // final dd = List.generate(
          //     //     20,
          //     //     (index) => UserData(
          //     //         imgList: [],
          //     //         id: index.toString(),
          //     //         name: "テストデータ",
          //     //         birthday: "",
          //     //         family: "",
          //     //         isGetData: false,
          //     //         isView: false,
          //     //         acquisitionAt:
          //     //             DateTime.now().subtract(Duration(hours: 23))));
          //     // final ss = await writeStoryData([
          //     //   UserData(
          //     //       imgList: [],
          //     //       id: "2WG8m5w5jyOUjgrLHfeGDnXxYX02",
          //     //       name: "テストデータ",
          //     //       birthday: "",
          //     //       family: "",
          //     //       isGetData: false,
          //     //       isView: false,
          //     //       acquisitionAt: DateTime.now().subtract(Duration(hours: 24)))
          //     // ]);
          //     // if (ss) {
          //     //   final ww = await readStoryData();
          //     //   print(ww);
          //     // } else {
          //     //   print("失敗");
          //     // }
          //   },
          // ),
          // SizedBox(
          //   height: safeAreaHeight * 0.11,
          // ),
        ],
      ),
    );
  }

  PreferredSizeWidget appberWithLogo(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          const SizedBox(),
        ],
      ),
    );
  }

  Widget storyLoadingWidget(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    return Container(
      alignment: Alignment.center,
      height: safeAreaHeight * 0.13,
      width: double.infinity,
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.white,
        size: MediaQuery.of(context).size.width / 13,
      ),
    );
  }

  Widget storyErrorWidget(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: safeAreaHeight * 0.13,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nText(
            "データ取得に失敗しました",
            color: Colors.white,
            fontSize: safeAreaWidth / 25,
            bold: 700,
          ),
          Padding(
            padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
            child: Material(
              color: blackColor,
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  alignment: Alignment.center,
                  height: safeAreaHeight * 0.04,
                  width: safeAreaWidth * 0.25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: nText(
                    "再試行",
                    color: Colors.white,
                    fontSize: safeAreaWidth / 30,
                    bold: 700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
