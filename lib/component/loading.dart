import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/img.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget loadinPage({
  required BuildContext context,
  required bool isLoading,
  required String? text,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Visibility(
    visible: isLoading,
    child: Container(
      alignment: Alignment.center,
      color: Colors.black.withOpacity(0.7),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            color: Colors.white,
            radius: safeAreaHeight * 0.018,
          ),
          if (text != null) ...{
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
              child: nText(
                text,
                color: Colors.white,
                fontSize: safeAreaWidth / 30,
                bold: 600,
              ),
            ),
          },
        ],
      ),
    ),
  );
}

class WithIconInLoadingPage extends HookConsumerWidget {
  const WithIconInLoadingPage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);

    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: safeAreaHeight * 0.15,
            width: safeAreaHeight * 0.15,
            decoration: BoxDecoration(image: appLogoImg()),
          ),
          CupertinoActivityIndicator(
            color: Colors.white,
            radius: safeAreaHeight * 0.018,
          ),
        ],
      ),
    );
  }
}

Widget messageLoading(BuildContext context) {
  final safeAreaHeight = safeHeight(context);
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: EdgeInsets.only(top: safeAreaHeight * 0.05),
      child: CupertinoActivityIndicator(
        color: Colors.white,
        radius: safeAreaHeight * 0.018,
      ),
    ),
  );
}

Widget storyLoadingWidget(BuildContext context) {
  final safeAreaHeight = safeHeight(context);
  return Container(
    alignment: Alignment.center,
    height: safeAreaHeight * 0.13,
    width: double.infinity,
    child: CupertinoActivityIndicator(
      color: Colors.white,
      radius: safeAreaHeight * 0.018,
    ),
  );
}

Widget loadinPageWithCncel({
  required BuildContext context,
  required bool isLoading,
  required String? text,
  required void Function() onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Visibility(
    visible: isLoading,
    child: GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Colors.black.withOpacity(0.7),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(
              color: Colors.white,
              radius: safeAreaHeight * 0.018,
            ),
            if (text != null) ...{
              Padding(
                padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
                child: nText(
                  text,
                  color: Colors.white,
                  fontSize: safeAreaWidth / 30,
                  bold: 600,
                ),
              ),
            },
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.02),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    alignment: Alignment.center,
                    height: safeAreaHeight * 0.04,
                    width: safeAreaWidth * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: nText(
                      "キャンセル",
                      color: Colors.red,
                      fontSize: safeAreaWidth / 30,
                      bold: 700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
