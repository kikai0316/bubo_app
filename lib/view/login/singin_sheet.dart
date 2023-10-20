import 'dart:async';
import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/widget/app_widget.dart';
import 'package:bubu_app/widget/login/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SingInSheetWidget extends HookConsumerWidget {
  SingInSheetWidget({super.key, required this.onTap});
  final controllerList = List.generate(3, (index) => TextEditingController());
  final void Function(UserData, String, String) onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final birthday = useState<String?>(null);
    final subTextList = ["メールアドレスを入力", "パスワードを入力", "ユーザー名を入力"];
    final iconList = [
      Icons.email,
      Icons.lock,
      Icons.person,
    ];
    final errorMessage =
        useState<List<String?>>(List.generate(4, (index) => null));
    Widget errorText(String text) {
      return Padding(
        padding: EdgeInsets.only(top: safeAreaHeight * 0.005),
        child: nText(
          text,
          color: Colors.red,
          fontSize: safeAreaWidth / 35,
          bold: 400,
        ),
      );
    }

    bool isCheck() {
      errorMessage.value = List.generate(4, (index) => null);
      bool isError = true;
      final isEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(controllerList[0].text);
      final isPassword = RegExp(
        r"^[a-zA-Z\d]+$",
      ).hasMatch(controllerList[1].text);
      // final RegExp(r"[!@#$%^&*(),.?\":{}|<>]").hasMatch(password)

      if (!isEmail || controllerList[0].text.isEmpty) {
        errorMessage.value[0] = "メールアドレスの形式が正しくありません";
        isError = false;
      }
      if (controllerList[1].text.length < 7 || !isPassword) {
        errorMessage.value[1] = "条件に合ったパスワードを設定してください";
        isError = false;
      }
      if (controllerList[2].text.isEmpty) {
        errorMessage.value[2] = "ユーザー名を入力してください";
        isError = false;
      }
      if (birthday.value == null || birthday.value!.isEmpty) {
        errorMessage.value[3] = "誕生日を入力してください";
        isError = false;
      }
      errorMessage.value = [...errorMessage.value];
      return isError;
    }

    return SizedBox(
      height: safeAreaHeight * 0.9,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWidget(
          context,
          "Sign Up!",
        ),
        body: SafeArea(
          child: Padding(
            padding: xPadding(context),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        for (int i = 0; i < 3; i++) ...{
                          Padding(
                            padding:
                                EdgeInsets.only(top: safeAreaHeight * 0.03),
                            child: LoginTextField(
                              icon: iconList[i],
                              isError: errorMessage.value[i] != null,
                              subText: "${subTextList[i]}...",
                              isPassword: i == 1,
                              controller: controllerList[i],
                              onChanged: (value) {
                                errorMessage.value[i] = null;
                                errorMessage.value = [...errorMessage.value];
                              },
                            ),
                          ),
                          if (i == 1) ...{
                            Padding(
                              padding:
                                  EdgeInsets.only(top: safeAreaHeight * 0.005),
                              child: nText(
                                "アルファベットの大文字・小文字,半角数字を使用して7文字以上",
                                color: Colors.grey,
                                fontSize: safeAreaWidth / 35,
                                bold: 400,
                              ),
                            ),
                          },
                          if (errorMessage.value[i] != null) ...{
                            errorText(errorMessage.value[i]!),
                          },
                        },
                        Padding(
                          padding: EdgeInsets.only(top: safeAreaHeight * 0.03),
                          child: birthdayWidget(
                            context,
                            isError: errorMessage.value[3] != null,
                            text: birthday.value,
                            onDataSet: (value) {
                              errorMessage.value[3] = null;
                              errorMessage.value = [...errorMessage.value];
                              birthday.value = value;
                            },
                          ),
                        ),
                        if (errorMessage.value[3] != null) ...{
                          errorText(errorMessage.value[3]!),
                        },
                        SizedBox(
                          height: safeAreaHeight * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: safeAreaHeight * 0.01),
                    child: bottomButton(
                      context: context,
                      isWhiteMainColor: false,
                      text: "新規登録",
                      onTap: () async {
                        primaryFocus?.unfocus();
                        if (isCheck()) {
                          await Future<void>.delayed(
                            const Duration(milliseconds: 500),
                          );
                          final dataSet = UserData(
                            imgList: [],
                            id: "",
                            name: controllerList[2].text,
                            birthday: birthday.value!,
                            family: "",
                            isGetData: true,
                            isView: false,
                            acquisitionAt: null,
                          );
                          onTap(
                            dataSet,
                            controllerList[0].text,
                            controllerList[1].text,
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
