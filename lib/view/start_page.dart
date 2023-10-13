import 'dart:ui';
import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/component.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/img.dart';
import 'package:bubu_app/constant/url.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/widget/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartPage extends HookConsumerWidget {
  const StartPage({super.key, required this.isCloseButton});
  final bool isCloseButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    // final List<String> title = [
    //   "ログイン",
    //   "新規登録",
    // ];
    void showSnackbar() {
      errorSnackbar(
        context,
        text: "エラーが発生しました",
        padding: 0,
      );
    }

    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          if (isCloseButton) ...{
            Align(
              child: Padding(
                padding: EdgeInsets.only(right: safeAreaWidth * 0.04),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          }
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: safeAreaWidth * 0.06,
              right: safeAreaWidth * 0.06,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: safeAreaHeight * 0.06,
                      bottom: safeAreaHeight * 0.2,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        height: safeAreaHeight * 0.15,
                        width: safeAreaHeight * 0.15,
                        decoration: BoxDecoration(
                          image: appLogoImg(),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: safeAreaHeight * 0.02,
                        top: safeAreaHeight * 0,
                      ),
                      child: privacyText(
                        context: context,
                        onTap1: () => openURL(
                          url: termsURL,
                          onError: () => showSnackbar(),
                        ),
                        onTap2: () => openURL(
                          url: privacyURL,
                          onError: () => showSnackbar(),
                        ),
                      ),
                    ),
                  ],
                ),
                bottomButton(
                  context: context,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  text: "ログイン",
                  onTap: () {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: safeAreaHeight * 0.01,
                  ),
                  child: loginLine(
                    context,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: safeAreaHeight * 0.03,
                    bottom: safeAreaHeight * 0.02,
                  ),
                  child: GestureDetector(
                    // onTap: () => Navigator.push<Widget>(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AdminLoginInPage(),
                    //   ),
                    // ),
                    child: Text(
                      "店舗ユーザーの方はこちら",
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontVariations: const [FontVariation("wght", 300)],
                        color: blueColor,
                        fontSize: safeAreaWidth / 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginLine(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: safeAreaHeight * 0.05,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: line(context, bottom: 0, top: 0),
          ),
          Padding(
            padding: EdgeInsets.all(safeAreaWidth * 0.025),
            child: Text(
              "または",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: safeAreaWidth / 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: line(context, bottom: 0, top: 0),
          ),
        ],
      ),
    );
  }
}
