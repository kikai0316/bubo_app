import 'dart:async';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/url.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/secure_storage_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/account/profile_setting.dart';
import 'package:bubu_app/view/login.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/loading_model.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/widget/account/account_widgt.dart';
import 'package:bubu_app/widget/home/home_story_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final notifier = ref.watch(storyListNotifierProvider);
    final int? notifierWhen = notifier.when(
      data: (data) => countDataForToday(data),
      error: (e, s) => null,
      loading: () => null,
    );
    void showSnackbar() {
      errorSnackbar(
        context,
        text: "サーバーとの通信に失敗しました。",
        padding: safeAreaHeight * 0.01,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: safeAreaWidth * 0.9,
                decoration: BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    safeAreaHeight * 0.02,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: safeAreaHeight * 0.105,
                        child: OnStory(
                          isImgOnly: true,
                          isMyData: true,
                          userData: userData,
                          onTap: () {},
                          isNearby: false,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: safeAreaHeight * 0.01,
                          bottom: safeAreaHeight * 0.015,
                        ),
                        child: nText(
                          userData.name,
                          color: Colors.white,
                          fontSize: safeAreaWidth / 20,
                          bold: 700,
                        ),
                      ),
                      Material(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => screenTransitionNormal(
                            context,
                            ProfileSetting(
                              userData: userData,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            alignment: Alignment.center,
                            height: safeAreaHeight * 0.05,
                            width: safeAreaWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: nText(
                              "プロフィールを編集",
                              color: Colors.white,
                              fontSize: safeAreaWidth / 30,
                              bold: 700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: safeAreaHeight * 0.02,
                  bottom: safeAreaHeight * 0.01,
                ),
                child:
                    accountMainWidget(context, isEncounter: false, data: 1000),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: safeAreaHeight * 0.01,
                ),
                child: accountMainWidget(
                  context,
                  isEncounter: true,
                  data: notifierWhen ?? 0,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: safeAreaWidth * 0.1,
                    top: safeAreaHeight * 0.04,
                    bottom: safeAreaHeight * 0.01,
                  ),
                  child: Text(
                    "設定・その他",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: safeAreaWidth / 25,
                    ),
                  ),
                ),
              ),
              Container(
                width: safeAreaWidth * 0.9,
                decoration: BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < 4; i++) ...{
                      settingWidget(
                        onTap: () {
                          if (i == 0) {
                            showAlertDialog(
                              context,
                              title: "バージョン",
                              subTitle: "12311",
                              buttonText: null,
                              ontap: null,
                            );
                          }
                          if (i == 1) {
                            openURL(url: termsURL, onError: null);
                          }
                          if (i == 2) {
                            openURL(url: privacyURL, onError: null);
                          }
                          if (i == 3) {
                            showAlertDialog(
                              context,
                              title: "アカウント削除",
                              subTitle: "アカウントを削除すると、すべてのデータが失われます。本当に削除しますか？",
                              buttonText: "削除する",
                              ontap: () async {
                                Navigator.pop(context);
                                final ss = ref
                                    .read(deviseListNotifierProvider.notifier);
                                ss.resetData();
                                final loadingNotifier =
                                    ref.read(loadingNotifierProvider.notifier);
                                loadingNotifier.upData(
                                  loadinPage(
                                    context: context,
                                    isLoading: true,
                                    text: "アカウント削除中...",
                                  ),
                                );
                                final dbDelete = await dbImgAllDelete(userData);
                                final localDelete =
                                    await deleteAllFile(userData.id);
                                if (dbDelete && localDelete) {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  final getAccountData =
                                      await readSecureStorage();
                                  if (user != null && getAccountData != null) {
                                    try {
                                      final AuthCredential credential =
                                          EmailAuthProvider.credential(
                                        email: getAccountData["email"]!,
                                        password: getAccountData["password"]!,
                                      );
                                      await user.reauthenticateWithCredential(
                                        credential,
                                      );
                                      await user.delete();
                                      await Future<void>.delayed(
                                        const Duration(seconds: 1),
                                      );
                                      loadingNotifier.upData(null);
                                      // ignore: use_build_context_synchronously
                                      screenTransitionToTop(
                                        context,
                                        const StartPage(),
                                      );
                                    } on FirebaseException {
                                      loadingNotifier.upData(null);
                                      showSnackbar();
                                    }
                                  } else {
                                    loadingNotifier.upData(null);
                                    showSnackbar();
                                  }
                                } else {
                                  loadingNotifier.upData(null);
                                  showSnackbar();
                                }
                              },
                            );
                          }
                        },
                        context: context,
                        isRedTitle: i == 3,
                        iconText: settingTitle[i],
                        isOnlyTopRadius: i == 0,
                        isOnlyBottomRadius: i == 3,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.8),
                          size: safeAreaWidth / 21,
                        ),
                      ),
                    },
                  ],
                ),
              ),
              SizedBox(
                height: safeAreaHeight * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int countDataForToday(List<UserData> data) {
  final DateTime now = DateTime.now();
  final DateTime startOfDay = DateTime(now.year, now.month, now.day);
  final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
  int count = 0;
  for (int i = 0; i < data.length; i++) {
    if (data[i].acquisitionAt != null &&
        data[i].acquisitionAt!.isAfter(startOfDay) &&
        data[i].acquisitionAt!.isBefore(endOfDay)) {
      count++;
    }
  }
  return count;
}
