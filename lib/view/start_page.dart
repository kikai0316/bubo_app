import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/component.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/img.dart';
import 'package:bubu_app/constant/url.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/login/login_sheet.dart';
import 'package:bubu_app/view/login/singin_sheet.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:bubu_app/widget/login/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartPage extends HookConsumerWidget {
  const StartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isLoading = useState<bool>(false);
    void showSnackbar(String text) {
      errorSnackbar(
        context,
        text: text,
        padding: 0,
      );
    }

    Future<void> nextPage(UserData userData) async {
      final isSuccess = await writeUserData(userData);
      final notifier = ref.read(userDataNotifierProvider.notifier);
      notifier.reLoad();
      isLoading.value = false;
      if (isSuccess) {
        // ignore: use_build_context_synchronously
        //後
        // Navigator.push<Widget>(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const UserApp(),
        //   ),
        // );
      } else {
        showSnackbar("エラーが発生しました。");
      }
    }

    Future<void> logIn(String email, String password) async {
      try {
        isLoading.value = true;
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final UserData? getData = await getImg(user.uid);
          if (getData != null) {
            nextPage(getData);
          } else {
            isLoading.value = false;
            showSnackbar("エラーが発生しました。");
          }
        } else {
          isLoading.value = false;
          showSnackbar("エラーが発生しました。");
        }
      } catch (e) {
        isLoading.value = false;
        showSnackbar("アカウントが見つかりませんでした。");
      }
    }

    Future<void> singInUp(
      UserData userData,
      String email,
      String passwprd,
    ) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      try {
        isLoading.value = true;
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: passwprd,
        );
        final User? user = auth.currentUser;
        if (user != null) {
          final dataSet = UserData(
            imgList: [],
            id: user.uid,
            name: userData.name,
            birthday: userData.birthday,
            family: "fdsaaa",
          );
          nextPage(dataSet);
        } else {
          isLoading.value = false;
          showSnackbar("エラーが発生しました");
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'email-already-in-use') {
          showSnackbar("指定されたメールアドレスはすでに使用されています。");
        } else {
          showSnackbar("エラーが発生しました");
        }
      }
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: blackColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: safeAreaWidth * 0.06,
                  right: safeAreaWidth * 0.06,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: safeAreaHeight * 0.06,
                          bottom: safeAreaHeight * 0.2,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            height: safeAreaHeight * 0.15,
                            width: safeAreaHeight * 0.15,
                            decoration: BoxDecoration(
                              image: appLogoImg(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: safeAreaHeight * 0.05,
                          ),
                          child: privacyText(
                            context: context,
                            onTap1: () => openURL(
                              url: termsURL,
                              onError: () => showSnackbar("エラーが発生しました"),
                            ),
                            onTap2: () => openURL(
                              url: privacyURL,
                              onError: () => showSnackbar("エラーが発生しました"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomButton(
                      context: context,
                      isWhiteMainColor: true,
                      text: "ログイン",
                      onTap: () => bottomSheet(
                        context,
                        page: LoginSheetWidget(
                          onTap: (email, password) => logIn(email, password),
                        ),
                        isBackgroundColor: true,
                        isPOP: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: safeAreaHeight * 0.01,
                      ),
                      child: loginLine(
                        context,
                      ),
                    ),
                    borderButton(
                      context: context,
                      text: "新規登録",
                      onTap: () => bottomSheet(
                        context,
                        page: SingInSheetWidget(
                          onTap: (value, email, password) =>
                              singInUp(value, email, password),
                        ),
                        isBackgroundColor: true,
                        isPOP: true,
                      ),
                    ),
                    SizedBox(
                      height: safeAreaHeight * 0.02,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        loadinPage(context: context, isLoading: isLoading.value, text: null)
      ],
    );
  }

  Widget loginLine(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: safeAreaHeight * 0.05,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: line(context, bottom: 0, top: 0),
          ),
          Padding(
            padding: EdgeInsets.all(safeAreaWidth * 0.025),
            child: Text(
              "または",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: safeAreaWidth / 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: line(context, bottom: 0, top: 0),
          ),
        ],
      ),
    );
  }
}
