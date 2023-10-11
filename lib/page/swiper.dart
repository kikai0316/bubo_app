import 'dart:ui';

import 'package:bubu_app/constant/dummy_data.dart';
import 'package:bubu_app/constant/text.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final TextEditingController controller = TextEditingController();

class SwiperPage extends HookConsumerWidget {
  const SwiperPage({super.key, required this.heroTag});
  final String heroTag;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey sliderKey = GlobalKey();
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isTextFiled = useState<bool>(false);
    return Hero(
      tag: heroTag,
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: CarouselSlider.builder(
            key: sliderKey,
            unlimitedMode: true,
            slideTransform: const CubeTransform(),
            itemCount: dummyImgList.length,
            slideBuilder: (index) {
              return Column(
                children: [
                  Expanded(
                    child: OnSwiper(
                      imgList: dummyImgList[index],
                      onNext: () {},
                      onBack: () {},
                    ),
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (int i = 0; i < 2; i++) ...{
                          Material(
                            color: Colors.black.withOpacity(0),
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: () {
                                isTextFiled.value = true;
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                alignment: Alignment.center,
                                height: safeAreaHeight * 0.05,
                                width: safeAreaWidth * 0.48,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: nText(
                                  i == 0 ? "InstagramをGETする" : "メッセージを送信...",
                                  color: Colors.white,
                                  fontSize: safeAreaWidth / 30,
                                  bold: 400,
                                ),
                              ),
                            ),
                          )
                        }
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
        bottomSheet: Visibility(
          visible: isTextFiled.value,
          child: Container(
            alignment: Alignment.center,
            height: safeAreaHeight * 0.05,
            width: safeAreaWidth * 0.9,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.3),
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextFormField(
              autofocus: true,
              controller: controller,
              onChanged: (index) {},
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: "Normal",
                fontVariations: const [FontVariation("wght", 400)],
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: safeAreaWidth / 30,
              ),
              decoration: InputDecoration(
                // enabledBorder: UnderlineInputBorder(
                //   borderSide: BorderSide(
                //     color: Colors.grey.withOpacity(0.5),
                //   ),
                // ),
                // focusedBorder: UnderlineInputBorder(
                //   borderSide: BorderSide(
                //     color: Colors.grey.withOpacity(0.5),
                //   ),
                // ),
                hintText: "メッセージを送信...",
                hintStyle: TextStyle(
                  fontFamily: "Normal",
                  fontVariations: const [FontVariation("wght", 700)],
                  color: Colors.grey.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: safeAreaWidth / 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnSwiper extends HookConsumerWidget {
  const OnSwiper({
    super.key,
    required this.imgList,
    required this.onNext,
    required this.onBack,
  });
  final List<String> imgList;
  final void Function() onNext;
  final void Function() onBack;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final imgIndex = useState<int>(0);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgList[imgIndex.value]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
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
                        if (imgIndex.value < imgList.length - 1) {
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
              }
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: safeAreaHeight * 0.1,
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
                        for (int i = 0; i < imgList.length; i++) ...{
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
                          if (i < imgList.length - 1)
                            SizedBox(width: safeAreaWidth * 0.01),
                        },
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: safeAreaHeight * 0.015),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: safeAreaWidth * 0.77,
                            ),
                            child: nText(
                              "だおすけああああああ",
                              color: Colors.white,
                              fontSize: safeAreaWidth / 18,
                              bold: 400,
                            ),
                          ),
                          nText(
                            "（ 21 ）",
                            color: Colors.white,
                            fontSize: safeAreaWidth / 25,
                            bold: 400,
                          ),
                        ],
                      ),
                    )
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
