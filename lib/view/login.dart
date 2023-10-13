import 'dart:ui';

import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/user_app.dart';
import 'package:bubu_app/widget/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isLoading = useState<bool>(false);
    final userID = useState<String>("");
    final userNAME = useState<String>("");
    final userIMG = useState<List<Uint8List>>([]);
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: blackColor,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 2; i++) ...{
                        nText(
                          i == 0 ? "id" : "name",
                          color: Colors.white,
                          fontSize: safeAreaWidth / 30,
                          bold: 700,
                        ),
                        SizedBox(
                          height: safeAreaHeight * 0.1,
                          width: safeAreaWidth * 0.8,
                          child: TextFormField(
                            autofocus: true,
                            onChanged: (text) {
                              if (i == 0) {
                                userID.value = text;
                              } else {
                                userNAME.value = text;
                              }
                            },
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Normal",
                              fontVariations: const [
                                FontVariation("wght", 400)
                              ],
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: safeAreaWidth / 25,
                            ),
                            decoration: InputDecoration(
                              // enabledBorder: InputBorder.none,
                              // focusedBorder: InputBorder.none,
                              hintText: "入力してください",
                              hintStyle: TextStyle(
                                fontFamily: "Normal",
                                fontVariations: const [
                                  FontVariation("wght", 700)
                                ],
                                color: Colors.white,
                                fontSize: safeAreaWidth / 28,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: safeAreaHeight * 0.1,
                        )
                      },
                      Row(
                        children: [
                          upWidget(
                            context,
                            onTap: () async {
                              isLoading.value = true;
                              await getMobileImage(
                                onSuccess: (value) {
                                  userIMG.value = [...userIMG.value, value];
                                },
                                onError: () {},
                              );
                              isLoading.value = false;
                            },
                          ),
                          for (int i = 0; i < userIMG.value.length; i++) ...{
                            imgWidget(
                              context,
                              img: userIMG.value[i],
                              onTap: () {
                                userIMG.value.removeAt(i);
                                userIMG.value = [
                                  ...userIMG.value,
                                ];
                              },
                            )
                          }
                        ],
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      bottomButton(
                        context: context,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        text: "新規登録",
                        onTap: () async {
                          isLoading.value = true;
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: "",
                              password: "",
                            );

                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            final setData = UserData(
                              imgList: userIMG.value,
                              id: user!.uid,
                              name: userNAME.value,
                            );
                            final isSuccess = await writeUserData(setData);
                            if (isSuccess) {
                              isLoading.value = false;
                              //ignore: use_build_context_synchronously
                              Navigator.push<Widget>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserApp(
                                    userData: setData,
                                  ),
                                ),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              errorSnackbar(
                                context,
                                text: "エラーが発生しました",
                                padding: safeAreaHeight * 0.09,
                              );
                            }
                          } catch (e) {
                            isLoading.value = false;
                            errorSnackbar(
                              context,
                              text: "アカウントが見つかりませんでした。",
                              padding: safeAreaHeight * 0.09,
                            );
                          }
                        },
                      ),
                      bottomButton(
                        context: context,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        text: "ログイン",
                        onTap: () async {
                          isLoading.value = true;

                          final setData = UserData(
                            imgList: userIMG.value,
                            id: userID.value,
                            name: userNAME.value,
                          );
                          final isSuccess = await writeUserData(setData);
                          if (isSuccess) {
                            isLoading.value = false;
                            //ignore: use_build_context_synchronously
                            Navigator.push<Widget>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserApp(
                                  userData: setData,
                                ),
                              ),
                            );
                          } else {}
                          isLoading.value = false;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        loadinPage(context: context, isLoading: isLoading.value, text: null)
      ],
    );
  }
}
