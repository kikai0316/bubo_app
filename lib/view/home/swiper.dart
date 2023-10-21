import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/message_sheet.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/view_model/user_data.dart';
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
  });
  final int index;
  final bool isMyData;
  final List<UserData> storyList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState<int>(index + 1);
    final safeAreaHeight = safeHeight(context);
    final deviceList = ref.watch(deviseListNotifierProvider);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isMove = useState<bool>(false);

    final scrollBack = useState<double>(0);
    final dataList = useState<List<UserData>>([...storyList]);
    bool isNotScreen(int index) {
      if (index == 0 || index == dataList.value.length + 1) {
        return true;
      } else {
        return false;
      }
    }

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
                                  child: OnSwiper(
                                    isMyData: isMyData,
                                    isNearby: deviceList
                                        .contains(dataList.value[index - 1].id),
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
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: SizedBox(
                                    height: safeAreaHeight * 0.07,
                                    width: safeAreaWidth * 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        for (int i = 0; i < 2; i++) ...{
                                          Material(
                                            color: Colors.black.withOpacity(0),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: InkWell(
                                              onTap: () {
                                                if (i == 0) {}
                                                if (i == 1) {
                                                  bottomSheet(
                                                    context,
                                                    page: MessageBottomSheet(),
                                                    isPOP: true,
                                                    isBackgroundColor: false,
                                                  );
                                                }
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: safeAreaHeight * 0.05,
                                                width: safeAreaWidth * 0.48,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 0.3,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: nText(
                                                  i == 0
                                                      ? "InstagramをGETする"
                                                      : "メッセージを送信...",
                                                  color: Colors.white,
                                                  fontSize: safeAreaWidth / 37,
                                                  bold: 200,
                                                ),
                                              ),
                                            ),
                                          ),
                                        },
                                      ],
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

// late UserData onSwiperData;

class OnSwiper extends HookConsumerWidget {
  const OnSwiper({
    super.key,
    required this.isMyData,
    required this.isNearby,
    required this.data,
    required this.onNext,
    required this.onBack,
  });
  final UserData data;
  final bool isMyData;
  final bool isNearby;
  final void Function() onNext;
  final void Function() onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final imgIndex = useState<int>(data.isView ? data.imgList.length - 1 : 0);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: data.isGetData
            ? DecorationImage(
                image: MemoryImage(data.imgList[imgIndex.value]),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              for (int i = 0; i < 2; i++) ...{
                Expanded(
                  child: GestureDetector(
                    onTap: context.mounted
                        ? () {
                            if (i == 0) {
                              if (imgIndex.value > 0) {
                                imgIndex.value--;
                              } else {
                                onBack();
                              }
                            } else {
                              if (imgIndex.value < data.imgList.length - 1) {
                                imgIndex.value++;
                                if (imgIndex.value == data.imgList.length - 1) {
                                  final setData = UserData(
                                    imgList: data.imgList,
                                    id: data.id,
                                    name: data.name,
                                    acquisitionAt: data.acquisitionAt,
                                    isGetData: data.isGetData,
                                    isView: true,
                                    birthday: data.birthday,
                                    family: data.family,
                                  );
                                  if (isMyData) {
                                    final notifier = ref.read(
                                      userDataNotifierProvider.notifier,
                                    );
                                    notifier.isViewupData();
                                  } else {
                                    final notifier = ref.read(
                                      storyListNotifierProvider.notifier,
                                    );
                                    notifier.dataUpDate(setData);
                                  }
                                }
                              } else {
                                onNext();
                              }
                            }
                          }
                        : null,
                    child: Container(
                      height: double.infinity,
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                ),
              },
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: safeAreaHeight * 0.1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: safeAreaHeight * 0.02,
                  left: safeAreaWidth * 0.04,
                  right: safeAreaWidth * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!data.isGetData) ...{
                      Container(
                        height: safeAreaHeight * 0.005,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    } else ...{
                      Row(
                        children: [
                          for (int i = 0; i < data.imgList.length; i++) ...{
                            Expanded(
                              child: Opacity(
                                opacity: i == imgIndex.value ? 1 : 0.4,
                                child: Container(
                                  height: safeAreaHeight * 0.005,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                            if (i < data.imgList.length - 1)
                              SizedBox(width: safeAreaWidth * 0.01),
                          },
                        ],
                      ),
                    },
                    SizedBox(height: safeAreaHeight * 0.01),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SizedBox(
                        width: safeAreaWidth * 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: safeAreaWidth * 0.7,
                                  ),
                                  child: nTextWithShadow(
                                    // data.name,
                                    "あああああああああああああああああ",
                                    color: Colors.white,
                                    fontSize: safeAreaWidth / 16,
                                    bold: 700,
                                  ),
                                ),
                                nTextWithShadow(
                                  "（ 21 ）",
                                  color: Colors.white,
                                  fontSize: safeAreaWidth / 26,
                                  bold: 700,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Opacity(
                                opacity: 0.7,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 0.8,
                                    ),
                                  ],
                                  size: safeAreaWidth / 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isMyData)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(safeAreaWidth * 0.03),
                child: Container(
                  alignment: Alignment.center,
                  height: safeAreaHeight * 0.04,
                  width: safeAreaWidth * 0.3,
                  decoration: BoxDecoration(
                    color: isNearby ? greenColor : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: nText(
                    "付近いいます",
                    color: isNearby ? Colors.white : Colors.black,
                    fontSize: safeAreaWidth / 25,
                    bold: 700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
