import 'dart:async';

import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/url.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/secure_storage_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/login.dart';
import 'package:bubu_app/view_model/device_list.dart';
import 'package:bubu_app/view_model/loading_model.dart';
import 'package:bubu_app/widget/account/account_widgt.dart';
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
              Padding(
                padding: EdgeInsets.only(
                  top: safeAreaHeight * 0.03,
                  bottom: safeAreaHeight * 0.03,
                ),
                child: AccountMain(userData: userData),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: safeAreaWidth * 0.1,
                    bottom: safeAreaHeight * 0.01,
                  ),
                  child: Text(
                    "アカウント",
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
                child: Padding(
                  padding: EdgeInsets.only(
                    top: safeAreaHeight * 0.001,
                    bottom: safeAreaHeight * 0.001,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < 1; i++) ...{
                        settingWidget(
                          isRedTitle: false,
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withOpacity(0.8),
                            size: safeAreaWidth / 21,
                          ),
                          isOnlyTopRadius: i == 0,
                          isOnlyBottomRadius: i == 0,
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
                          },
                          context: context,
                          iconText: settingTitle[i],
                        ),
                      },
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: safeAreaWidth * 0.1,
                    top: safeAreaHeight * 0.02,
                    bottom: safeAreaHeight * 0.01,
                  ),
                  child: Text(
                    "その他",
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
                    for (int i = 1; i < 4; i++) ...{
                      settingWidget(
                        onTap: () {
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
                                loadingNotifier.upDateTrue();
                                final dbDelete = await accountDelete(userData);
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
                                      loadingNotifier.upDateFalse();
                                      // ignore: use_build_context_synchronously
                                      screenTransitionToTop(
                                        context,
                                        const StartPage(),
                                      );
                                    } on FirebaseException {
                                      loadingNotifier.upDateFalse();
                                      showSnackbar();
                                    }
                                  } else {
                                    loadingNotifier.upDateFalse();
                                    showSnackbar();
                                  }
                                } else {
                                  loadingNotifier.upDateFalse();
                                  showSnackbar();
                                }
                              },
                            );
                          }
                        },
                        context: context,
                        isRedTitle: i == 3,
                        iconText: settingTitle[i],
                        isOnlyTopRadius: i == 1,
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
                height: safeAreaHeight * 0.15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
