import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

PreferredSizeWidget appberWithLogo(BuildContext context) {
  final safeAreaHeight = safeHeight(context);
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Container(
      height: safeAreaHeight * 0.08,
      width: safeAreaHeight * 0.08,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/logo.png"),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

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
  final void Function()? onTap;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final baseHeight = safeAreaHeight * 0.18;
    final calculatedWidth = baseHeight * (3 / 2);

    return Padding(
      padding: EdgeInsets.only(right: safeAreaWidth * 0.04),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          // tag: data.id,
          tag: "${data.id}$index",
          child: SizedBox(
            width: safeAreaHeight * 0.12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: baseHeight,
                  width: calculatedWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
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
                          decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(safeAreaHeight * 0.0035),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                image: data.imgList.isEmpty
                                    ? null
                                    : DecorationImage(
                                        image: MemoryImage(data.imgList.first),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isMyData)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.all(safeAreaHeight * 0.01),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                height: safeAreaHeight * 0.035,
                                width: safeAreaHeight * 0.035,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: safeAreaWidth / 25,
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: safeAreaHeight * 0.005),
                  child: nText(
                    data.name,
                    color: Colors.white.withOpacity(0.9),
                    fontSize: safeAreaWidth / 45,
                    bold: 200,
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

Widget onTalk(
  BuildContext context,
) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(
      top: safeAreaHeight * 0.03,
      left: safeAreaWidth * 0.03,
      right: safeAreaWidth * 0.03,
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/test.png"),
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
                  "あssでう",
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
  );
}
