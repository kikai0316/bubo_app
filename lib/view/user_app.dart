import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/account.dart';
import 'package:bubu_app/view/home.dart';
import 'package:bubu_app/view/home/not_image_page.dart';
import 'package:bubu_app/view/login.dart';
import 'package:bubu_app/view_model/loading_model.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserApp extends HookConsumerWidget {
  const UserApp({super.key, required this.initPage});
  final int initPage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final loadingNotifier = ref.watch(loadingNotifierProvider);
    final selectInt = useState<int>(initPage);
    final notifier = ref.watch(userDataNotifierProvider);
    final notImgPage = useState<bool>(false);
    final notifierWhen = notifier.when(
      data: (data) {
        if (data != null) {
          if (data.imgList.isEmpty) {
            notImgPage.value = true;
            return NotImgPage(
              userData: data,
            );
          } else {
            notImgPage.value = false;
            return selectInt.value == 0
                ? HomePage(userData: data)
                : AccountPage(userData: data);
          }
        } else {
          return errorWidget(
            context,
          );
        }
      },
      error: (e, s) => errorWidget(
        context,
      ),
      loading: () => loadinPage(isLoading: true, text: null, context: context),
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: notImgPage.value
          ? notifierWhen
          : Stack(
              children: [
                Scaffold(
                  backgroundColor: blackColor,
                  extendBody: true,
                  resizeToAvoidBottomInset: false,
                  body: notifierWhen,
                  bottomNavigationBar: Container(
                    alignment: Alignment.topCenter,
                    height: safeAreaHeight * 0.1,
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < pageList.length; i++) ...{
                          GestureDetector(
                            onTap: () => selectInt.value = i,
                            child: Opacity(
                              opacity: selectInt.value == i ? 1 : 0.2,
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.black.withOpacity(0),
                                height: safeAreaHeight * 0.08,
                                width: safeAreaWidth * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      pageList[i].icon,
                                      size: i == 1
                                          ? safeAreaWidth / 12
                                          : safeAreaWidth / 14,
                                      color: Colors.white,
                                    ),
                                    nText(
                                      pageList[i].name,
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: safeAreaWidth / 40,
                                      bold: 400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                if (loadingNotifier != null) ...{
                  loadingNotifier,
                },
              ],
            ),
    );
  }
}

final List<BottomData> pageList = [
  BottomData(
    Icons.home,
    "ホーム",
  ),
  BottomData(
    Icons.person,
    "アカウント",
  ),
];

class BottomData {
  IconData icon;
  String name;
  BottomData(
    this.icon,
    this.name,
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
        ),
      ],
    ),
  );
}
