import 'package:bubu_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final safeAreaHeight = safeHeight(context);
    // final safeAreaWidth = MediaQuery.of(context).size.width;
    return const Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      body: Center(
        child: Text(
          "home",
          style: TextStyle(),
        ),
      ),
    );
  }
}
