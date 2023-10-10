import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/text.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appberWithLogo(BuildContext context) {
  final safeAreaHeight = safeHeight(context);
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Container(
      height: safeAreaHeight * 0.1,
      width: safeAreaHeight * 0.1,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/logo.png"),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

Widget onProfile(
  BuildContext context, {
  required bool isMyData,
  required UserData data,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final baseHeight = safeAreaHeight * 0.16;
  final calculatedWidth = baseHeight * (3 / 2);
  return Padding(
    padding: EdgeInsets.only(right: safeAreaWidth * 0.04),
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
                      child: Container(
                        alignment: Alignment.center,
                        height: safeAreaHeight * 0.03,
                        width: safeAreaHeight * 0.03,
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
                  )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: safeAreaHeight * 0.005),
            child: Text(
              data.id,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: safeAreaWidth / 30,
              ),
            ),
          )
        ],
      ),
    ),
  );
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
