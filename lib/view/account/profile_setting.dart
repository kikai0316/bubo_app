import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/user_app.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:bubu_app/widget/account/account_widgt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

TextEditingController? textController;

class ProfileSetting extends HookConsumerWidget {
  const ProfileSetting({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isLoading = useState<bool>(false);
    final editName = useState<String>(userData.name);
    final editInstagram = useState<String>(userData.instagram);
    final editBirthday = useState<String>(userData.birthday);
    final User? user = FirebaseAuth.instance.currentUser;
    final dataList = [
      editName.value,
      editInstagram.value,
      editBirthday.value,
      user?.email ?? "取得エラー",
    ];
    DateTime parseDate(String input) {
      final year = int.parse(input.substring(0, 4));
      final month = int.parse(input.substring(4, 6));
      final day = int.parse(input.substring(6, 8));

      return DateTime(year, month, day);
    }

    bool isDataCheck() {
      if (userData.name == editName.value &&
          userData.instagram == editInstagram.value &&
          userData.birthday == editBirthday.value) {
        return true;
      } else {
        return false;
      }
    }

    void showSnackbar() {
      errorSnackbar(
        context,
        text: "サーバーとの通信に失敗しました。",
        padding: safeAreaHeight * 0.08,
      );
    }

    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: nText(
              "プロフィール編集",
              color: Colors.white,
              fontSize: safeAreaWidth / 20,
              bold: 700,
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: safeAreaWidth / 15,
              ),
              onPressed: () {
                if (isDataCheck()) {
                  Navigator.of(context).pop();
                } else {
                  showAlertDialog(
                    context,
                    title: "変更内容が保存されていません",
                    subTitle: "このページを離れると、入力した内容は失われます。本当に離れますか？",
                    buttonText: "OK",
                    ontap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
            ),
          ),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: safeAreaHeight * 0.02),
                        child: Container(
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
                                for (int i = 0; i < dataList.length; i++) ...{
                                  Opacity(
                                    opacity: i != 3 ? 1 : 0.3,
                                    child: settingWidget(
                                      isOnlyBottomRadius:
                                          i == dataList.length - 1,
                                      isOnlyTopRadius: i == 0,
                                      isRedTitle: false,
                                      trailing: Container(
                                        alignment: Alignment.center,
                                        height: safeAreaHeight * 0.1,
                                        width: safeAreaWidth * 0.5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: safeAreaWidth * 0.02,
                                              ),
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: safeAreaWidth * 0.4,
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: nText(
                                                    dataList[i],
                                                    color: Colors.white,
                                                    fontSize:
                                                        safeAreaWidth / 28,
                                                    bold: 700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (i != 3)
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                size: safeAreaWidth / 21,
                                              ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        if (i < 2) {
                                          textController =
                                              TextEditingController(
                                            text: i == 0
                                                ? editName.value
                                                : editInstagram.value,
                                          );
                                          bottomSheet(
                                            context,
                                            isPOP: true,
                                            isBackgroundColor: true,
                                            page: UserEditSheet(
                                              isUserName: i == 0,
                                              controller: textController!,
                                              onTap: () {
                                                if (i == 0) {
                                                  editName.value =
                                                      textController!.text;
                                                } else {
                                                  editInstagram.value =
                                                      textController!.text;
                                                }
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        }
                                        if (i == 2) {
                                          primaryFocus?.unfocus();
                                          DatePicker.showDatePicker(
                                            context,
                                            minTime: DateTime(1950),
                                            maxTime: DateTime(2022, 8, 17),
                                            currentTime: parseDate(dataList[i]),
                                            locale: LocaleType.jp,
                                            onConfirm: (date) {
                                              editBirthday.value =
                                                  '${date.year} / ${date.month.toString().padLeft(2, '0')} / ${date.day.toString().padLeft(2, '0')}';
                                            },
                                          );
                                        }
                                      },
                                      context: context,
                                      iconText: profileSettingTitle[i],
                                    ),
                                  ),
                                },
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: isDataCheck() ? 0.3 : 1,
                    child: bottomButton(
                      context: context,
                      text: "保存",
                      isWhiteMainColor: true,
                      onTap: () async {
                        if (!isDataCheck()) {
                          isLoading.value = true;
                          primaryFocus?.unfocus();
                          final setData = UserData(
                            imgList: userData.imgList,
                            id: userData.id,
                            name: editName.value,
                            birthday: editBirthday.value,
                            family: userData.family,
                            instagram: editInstagram.value,
                            isGetData: userData.isGetData,
                            isView: userData.isView,
                            acquisitionAt: userData.acquisitionAt,
                          );
                          final bool dbUpData = await userDataUpData(setData);
                          if (dbUpData) {
                            final bool localWrite =
                                await writeUserData(setData);
                            if (localWrite) {
                              final notifier =
                                  ref.read(userDataNotifierProvider.notifier);
                              notifier.reLoad();
                              isLoading.value = false;
                              // ignore: use_build_context_synchronously
                              screenTransition(
                                context,
                                const UserApp(
                                  initPage: 1,
                                ),
                              );
                            } else {
                              isLoading.value = false;
                              showSnackbar();
                            }
                          } else {
                            isLoading.value = false;
                            showSnackbar();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        loadinPage(context: context, isLoading: isLoading.value, text: null),
      ],
    );
  }
}

final profileSettingTitle = [
  "ユーザー名",
  "Instagram",
  "生年月日",
  "メールアドレス",
];
