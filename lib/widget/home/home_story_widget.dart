import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnStory extends HookConsumerWidget {
  const OnStory({
    super.key,
    required this.isMyData,
    required this.userData,
    required this.onTap,
    required this.index,
    required this.isNearby,
  });
  final UserData userData;
  final void Function() onTap;
  final int index;
  final bool isMyData;
  final bool isNearby;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTapEvent = useState<bool>(false);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    useEffect(
      () {
        var cancelled = false;
        if (userData.imgList.isEmpty) {
          Future(() async {
            if (userData.imgList.isEmpty) {
              final getData = await imgMainGet(userData);
              if (cancelled) return;
              if (getData != null) {
                final notifier = ref.read(storyListNotifierProvider.notifier);
                notifier.dataUpDate(getData);
              }
            }
          });
        }
        return () {
          cancelled = true;
        };
      },
      [],
    );
    return Padding(
      padding: EdgeInsets.only(right: safeAreaHeight * 0.02),
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
          tag: userData.id,
          child: Container(
            alignment: Alignment.center,
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: userData.isView
                            ? Colors.grey.withOpacity(0.5)
                            : null,
                        gradient: userData.isView
                            ? null
                            : const LinearGradient(
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
                            padding: EdgeInsets.all(safeAreaHeight * 0.0035),
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: blackColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(safeAreaHeight * 0.004),
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    image: userData.imgList.isEmpty
                                        ? null
                                        : DecorationImage(
                                            image: MemoryImage(
                                              userData.imgList.first,
                                            ),
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
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: blueColor,
                                    size: safeAreaWidth / 18,
                                  ),
                                ),
                              ),
                            ),
                          } else ...{
                            if (isNearby) ...{
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            },
                          },
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: safeAreaHeight * 0.005),
                  child: nText(
                    userData.name,
                    color: Colors.white.withOpacity(0.9),
                    fontSize: safeAreaWidth / 35,
                    bold: 500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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