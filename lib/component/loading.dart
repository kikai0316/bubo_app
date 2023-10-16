import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/img.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      color: Colors.black.withOpacity(0.5),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: MediaQuery.of(context).size.width / 12,
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
          }
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
          Padding(
            padding: EdgeInsets.only(bottom: safeAreaHeight * 0.03),
            child: Container(
              height: safeAreaHeight * 0.15,
              width: safeAreaHeight * 0.15,
              decoration: BoxDecoration(image: appLogoImg()),
            ),
          ),
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: MediaQuery.of(context).size.width / 10,
          ),
        ],
      ),
    );
  }
}
