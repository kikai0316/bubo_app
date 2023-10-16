import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnStory extends HookConsumerWidget {
  const OnStory({
    super.key,
    required this.isMyData,
    required this.data,
    required this.onTap,
    required this.index,
  });
  final bool isMyData;
  final UserData data;
  final void Function() onTap;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isTapEvent = useState<bool>(false);
    return Padding(
      padding: EdgeInsets.only(right: safeAreaWidth * 0.03),
      child: GestureDetector(
        onTap: () {
          isTapEvent.value = false;
          onTap();
        },
        onTapDown: (TapDownDetails downDetails) {
          isTapEvent.value = true;
        },
        onTapCancel: () {
          isTapEvent.value = false;
        },
        child: Hero(
          tag: "${data.id}$index",
          child: SizedBox(
            height: safeAreaHeight * 0.13,
            width: safeAreaHeight * 0.105,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isTapEvent.value ? safeAreaWidth * 0.008 : 0,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: safeAreaHeight * 0.105,
                      width: safeAreaHeight * 0.105,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: FractionalOffset.topRight,
                          end: FractionalOffset.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 4, 15, 238),
                            Color.fromARGB(255, 6, 120, 255),
                            Color.fromARGB(255, 4, 200, 255),
                          ],
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(safeAreaHeight * 0.004),
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: blackColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(safeAreaHeight * 0.0035),
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    image: data.imgList.isEmpty
                                        ? null
                                        : DecorationImage(
                                            image:
                                                MemoryImage(data.imgList.first),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isMyData) ...{
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  height: safeAreaHeight * 0.038,
                                  width: safeAreaHeight * 0.038,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: blueColor,
                                    size: safeAreaWidth / 18,
                                  ),
                                ),
                              ),
                            )
                          } else ...{
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                alignment: Alignment.center,
                                height: safeAreaHeight * 0.03,
                                width: safeAreaHeight * 0.03,
                                decoration: BoxDecoration(
                                  color: greenColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: greenColor.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 1.0,
                                    )
                                  ],
                                ),
                              ),
                            )
                          }
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: safeAreaHeight * 0.005),
                  child: nText(
                    data.name,
                    color: Colors.white.withOpacity(0.9),
                    fontSize: safeAreaWidth / 35,
                    bold: 500,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget onMessage(BuildContext context, UserData userData) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      // onTap: () => Navigator.push<Widget>(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MessageScreenPage(
      //       myData: userData,
      //       partnerData: userData,
      //     ),
      //   ),
      // ),
      child: Container(
        width: double.infinity,
        color: Colors.black.withOpacity(0),
        child: Padding(
          padding: EdgeInsets.only(
            top: safeAreaHeight * 0.015,
            left: safeAreaWidth * 0.03,
            right: safeAreaWidth * 0.03,
            bottom: safeAreaHeight * 0.015,
          ),
          child: SizedBox(
            height: safeAreaHeight * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: safeAreaWidth * 0.05),
                  child: Container(
                    height: safeAreaHeight * 0.08,
                    width: safeAreaHeight * 0.08,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(userData.imgList.first),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nText(
                        userData.name,
                        color: Colors.white,
                        fontSize: safeAreaWidth / 27,
                        bold: 700,
                      ),
                      nText(
                        "あssでう",
                        color: Colors.grey,
                        fontSize: safeAreaWidth / 30,
                        bold: 500,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: safeAreaWidth * 0.1,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: nText(
                          "金曜日",
                          color: Colors.grey,
                          fontSize: safeAreaWidth / 35,
                          bold: 500,
                        ),
                      ),
                      Align(
                        child: Container(
                          height: safeAreaHeight * 0.02,
                          width: safeAreaHeight * 0.02,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 4, 15, 238),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget errorWidget(
  BuildContext context,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    color: blackColor,
    alignment: Alignment.topCenter,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        nText(
          "エラーが発生しました",
          color: Colors.white,
          fontSize: safeAreaWidth / 17,
          bold: 700,
        ),
        Padding(
          padding: EdgeInsets.only(top: safeAreaHeight * 0.05),
          child: nText(
            "ログイン情報が確認できませんでした。\nログインページから再度ログインを行ってください。",
            color: Colors.grey,
            fontSize: safeAreaWidth / 28,
            bold: 500,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: safeAreaHeight * 0.04,
            bottom: safeAreaHeight * 0.1,
          ),
          child: customButton(
            context: context,
            height: safeAreaHeight * 0.06,
            width: safeAreaWidth * 0.6,
            text: "ログインページへ",
            textColor: Colors.black,
            textSize: safeAreaWidth / 30,
            backgroundColor: Colors.white,
            onTap: () => screenTransitionToTop(context, const StartPage()),
          ),
        )
      ],
    ),
  );
}