import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoryAllPage extends HookConsumerWidget {
  const StoryAllPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: blackColor,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: nText(
          "過去24時間の履歴",
          color: Colors.white,
          fontSize: safeAreaWidth / 24,
          bold: 700,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            height: 0.5,
            color: Colors.grey,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

List<UserData> sortUserData(List<UserData> data, List<String> idList) {
  final List<UserData> list1 = [];
  final List<UserData> list2 = [];
  final List<UserData> list3 = [];
  final List<UserData> list4 = [];

  for (final user in data) {
    if (idList.contains(user.id) && !user.isView) {
      list1.add(user);
    } else if (idList.contains(user.id) && user.isView) {
      list2.add(user);
    } else if (!idList.contains(user.id) && !user.isView) {
      list3.add(user);
    } else if (!idList.contains(user.id) && user.isView) {
      list4.add(user);
    }
  }
  return [...list1, ...list2, ...list3, ...list4];
}
