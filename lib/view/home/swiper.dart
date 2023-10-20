import 'dart:typed_data';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/message_sheet.dart';
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
  });
  final int index;
  // final List<Map<String, dynamic>> storyList;
  final List<UserData> storyList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState<int>(index + 1);
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isMove = useState<bool>(false);
    final scrollBack = useState<double>(0);
    final imgList = useState<List<List<Uint8List>>>([]);

    Future<void> compressImage() async {
      for (int i = 0; i < storyList.length; i++) {
        // final List<Uint8List> list = [];
        // for (int a = 0; a < storyList[i].imgList.length; a++) {
        //   final compressedResult = await FlutterImageCompress.compressWithList(
        //     storyList[i].imgList[a],
        //     quality: 50, // 0-100間で圧縮の品質を指定します。ここでは70%の品質で圧縮しています。
        //   );
        //   list.add(Uint8List.fromList(compressedResult));
        // }
        imgList.value = [...imgList.value, storyList[i].imgList];
      }
    }

    bool isNotScreen(int index) {
      if (index == 0 || index == storyList.length + 1) {
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

    useEffect(
      () {
        compressImage();
        void listener() {
          if (scrollController.offset < -60) {
            if (scrollBack.value > scrollController.offset) {
              scrollBack.value = scrollController.offset;
            } else {
              Navigator.pop(context);
              scrollController.removeListener(listener);
            }
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
      tag: storyList.first.id,
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
                onSlideChanged: (value) {
                  if (isNotScreen(value)) {
                    Navigator.pop(context);
                  }
                  pageIndex.value = value;
                },
                slideTransform: const CubeTransform(),
                itemCount: imgList.value.length + 2,
                slideBuilder: (index) {
                  if (isNotScreen(index)) {
                    return Container(
                      height: double.infinity,
                      color: Colors.black,
                    );
                  } else {
                    return imgList.value.isEmpty
                        ? Container()
                        : SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: safeAreaHeight * 0.93,
                                  width: safeAreaWidth * 1,
                                  child: OnSwiper(
                                    data: imgList.value[index - 1],
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
    required this.data,
    required this.onNext,
    required this.onBack,
  });
  final List<Uint8List> data;
  final void Function() onNext;
  final void Function() onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final imgIndex = useState<int>(0);
    // precacheImages(context, data.imgList);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(data[imgIndex.value]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // for (int i = 0; i < data.imgList.length; i++) ...{
          //   Opacity(
          //     opacity: i == imgIndex.value ? 1 : 0,
          //     child: Container(
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           image: MemoryImage(data.imgList[i]),
          //           fit: BoxFit.cover,
          //         ),
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //     ),
          //   )
          // },
          Row(
            children: [
              for (int i = 0; i < 2; i++) ...{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (i == 0) {
                        if (imgIndex.value > 0) {
                          imgIndex.value--;
                        } else {
                          onBack();
                        }
                      } else {
                        if (imgIndex.value < data.length - 1) {
                          imgIndex.value++;
                        } else {
                          onNext();
                        }
                      }
                    },
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
                    Row(
                      children: [
                        for (int i = 0; i < data.length; i++) ...{
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
                          if (i < data.length - 1)
                            SizedBox(width: safeAreaWidth * 0.01),
                        },
                      ],
                    ),
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
                                    maxWidth: safeAreaWidth * 0.6,
                                  ),
                                  child: nTextWithShadow(
                                    // data.name,
                                    "ああああああああああああああああ",
                                    color: Colors.white,
                                    fontSize: safeAreaWidth / 22,
                                    bold: 400,
                                  ),
                                ),
                                nTextWithShadow(
                                  "（ 21 ）",
                                  color: Colors.white,
                                  fontSize: safeAreaWidth / 26,
                                  bold: 400,
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
        ],
      ),
    );
  }
}
