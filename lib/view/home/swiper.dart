import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/message_sheet.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/widget/home/swiper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ScrollController scrollController = ScrollController();
final CarouselSliderController controller = CarouselSliderController();

class SwiperPage extends HookConsumerWidget {
  const SwiperPage({
    super.key,
    required this.index,
    required this.storyList,
    required this.isMyData,
    required this.myUserData,
  });
  final int index;
  final bool isMyData;
  final List<UserData> storyList;
  final UserData myUserData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState<int>(index + 1);
    final safeAreaHeight = safeHeight(context);
    final deviceList = ref.watch(deviseListNotifierProvider);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isMove = useState<bool>(false);
    final message = useState<String?>(null);
    final scrollBack = useState<double>(0);
    final dataList = useState<List<UserData>>([...storyList]);
    bool isNotScreen(int index) {
      if (index == 0 || index == dataList.value.length + 1) {
        return true;
      } else {
        return false;
      }
    }

    final isNearby = !isNotScreen(pageIndex.value) &&
        deviceList.contains(
          dataList.value[pageIndex.value - 1].id,
        );
    Future<void> moveAnimation() async {
      isMove.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 300));
      isMove.value = false;
    }

    Future<void> fetchAndUpdate(int index) async {
      final getImg = await imgOtherGet(dataList.value[index]);
      if (getImg != null && !dataList.value[index].isGetData) {
        if (context.mounted) {
          final notifier = ref.read(storyListNotifierProvider.notifier);
          notifier.dataUpDate(getImg);
          dataList.value[index] = getImg;
          dataList.value = [...dataList.value];
        }
      }
    }

    Future<void> getOthers(int dataIndex) async {
      if (!dataList.value[dataIndex].isGetData) {
        fetchAndUpdate(dataIndex);
      }
      if (dataIndex + 1 < dataList.value.length &&
          !dataList.value[dataIndex + 1].isGetData) {
        fetchAndUpdate(dataIndex + 1);
      }
      if (dataIndex - 1 >= 0 && !dataList.value[dataIndex - 1].isGetData) {
        fetchAndUpdate(dataIndex - 1);
      } else if (dataIndex + 2 < dataList.value.length &&
          !dataList.value[dataIndex + 2].isGetData) {
        fetchAndUpdate(dataIndex + 2);
      }
    }

    Future<void> messageSend(String text) async {
      if (message.value == null) {
        message.value = text;
        await Future<void>.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          message.value = null;
        }
      }
    }

    useEffect(
      () {
        getOthers(index);
        void listener() {
          try {
            if (scrollController.offset < -60) {
              if (scrollBack.value > scrollController.offset) {
                scrollBack.value = scrollController.offset;
              } else {
                Navigator.pop(context);
                scrollController.removeListener(listener);
              }
            }
          } catch (e) {
            return;
          }
        }

        scrollController.addListener(listener);
        return () {
          scrollController.removeListener(listener);
        };
      },
      [],
    );

    return Hero(
      tag: pageIndex.value == 0
          ? dataList.value[0].id
          : pageIndex.value == dataList.value.length + 1
              ? dataList.value[dataList.value.length - 1].id
              : dataList.value[pageIndex.value - 1].id,
      child: Stack(
        children: [
          Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: CarouselSlider.builder(
                controller: controller,
                initialPage: index + 1,
                onSlideChanged: (value) async {
                  if (isNotScreen(value)) {
                    Navigator.pop(context);
                  } else {
                    getOthers(value - 1);
                  }
                  pageIndex.value = value;
                },
                slideTransform: const CubeTransform(),
                itemCount: dataList.value.length + 2,
                slideBuilder: (index) {
                  if (isNotScreen(index)) {
                    return Container(
                      height: double.infinity,
                      color: Colors.black,
                    );
                  } else {
                    return dataList.value.isEmpty
                        ? Container()
                        : SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: safeAreaHeight * 0.93,
                                  width: safeAreaWidth * 1,
                                  child: Stack(
                                    children: [
                                      OnSwiper(
                                        isMyData: isMyData,
                                        isNearby: isNearby,
                                        data: dataList.value[index - 1],
                                        onNext: () {
                                          moveAnimation();
                                          controller.nextPage(
                                            const Duration(milliseconds: 300),
                                          );
                                        },
                                        onBack: () {
                                          if (index != 1) {
                                            moveAnimation();
                                            controller.previousPage(
                                              const Duration(milliseconds: 300),
                                            );
                                          }
                                        },
                                      ),
                                      Visibility(
                                        visible: message.value != null,
                                        child: GestureDetector(
                                          onTap: () => message.value = null,
                                          child: messageWidget(
                                            context,
                                            message.value ?? "",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: SizedBox(
                                    height: safeAreaHeight * 0.07,
                                    width: safeAreaWidth * 1,
                                    child: Opacity(
                                      opacity: isMyData ? 0.5 : 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          for (int i = 0; i < 2; i++) ...{
                                            Opacity(
                                              opacity: !isMyData &&
                                                      !isNearby &&
                                                      i == 1
                                                  ? 0.5
                                                  : 1,
                                              child: Material(
                                                color:
                                                    Colors.black.withOpacity(0),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: InkWell(
                                                  onTap: isMyData
                                                      ? null
                                                      : () {
                                                          if (i == 0) {}
                                                          if (i == 1) {
                                                            if (isNearby) {
                                                              bottomSheet(
                                                                context,
                                                                page:
                                                                    MessageBottomSheet(
                                                                  myUserData:
                                                                      myUserData,
                                                                  userData: dataList
                                                                          .value[
                                                                      index -
                                                                          1],
                                                                  onTap: () =>
                                                                      messageSend(
                                                                    "メッセージを送信しました",
                                                                  ),
                                                                ),
                                                                isPOP: true,
                                                                isBackgroundColor:
                                                                    false,
                                                              );
                                                            } else {
                                                              messageSend(
                                                                "相手が通信範囲外です。",
                                                              );
                                                            }
                                                          }
                                                        },
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        safeAreaHeight * 0.05,
                                                    width: safeAreaWidth * 0.48,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 0.3,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        50,
                                                      ),
                                                    ),
                                                    child: nText(
                                                      i == 0
                                                          ? "InstagramをGETする"
                                                          : "メッセージを送信...",
                                                      color: Colors.white,
                                                      fontSize:
                                                          safeAreaWidth / 37,
                                                      bold: 200,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          },
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: safeAreaHeight * 0.01,
                                ),
                              ],
                            ),
                          );
                  }
                },
              ),
            ),
          ),
          Visibility(
            visible: isMove.value,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0),
            ),
          ),
        ],
      ),
    );
  }
}
