import 'dart:ui';
import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotInstagramPage extends HookConsumerWidget {
  const NotInstagramPage({
    super.key,
    required this.userData,
  });
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final text = useState<String>("");
    final errorText = useState<String?>(null);
    final isLoading = useState<bool>(false);

    Future<void> dataUpLoad() async {
      isLoading.value = true;
      final setData = UserData(
        imgList: userData.imgList,
        id: userData.id,
        name: userData.name,
        birthday: userData.birthday,
        family: userData.family,
        instagram: text.value,
        isGetData: true,
        isView: false,
        acquisitionAt: null,
      );
      final iswWite = await writeUserData(setData);
      if (iswWite) {
        final notifier = ref.read(userDataNotifierProvider.notifier);
        notifier.reLoad();
      } else {
        isLoading.value = false;
        // ignore: use_build_context_synchronously
        errorSnackbar(
          text: "何らかの問題が発生しました。再試行してください。",
          padding: safeAreaHeight * 0.08,
        );
      }
    }

    bool isCheck() {
      errorText.value = null;
      bool isError = true;
      if (text.value.isEmpty) {
        errorText.value = "InstagramのユーザーIDを入力してください。";
        isError = false;
      }
      if (!RegExp(r'^[a-z0-9_.]+$').hasMatch(text.value)) {
        errorText.value = "正確なInstagramのユーザーIDを入力してください。";
        isError = false;
      }

      return isError;
    }

    return Scaffold(
      backgroundColor: blackColor,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: safeAreaHeight * 0.06,
                      bottom: safeAreaHeight * 0.06,
                    ),
                    child: nText(
                      "InstagramのアカウントIDを\n入力してください",
                      color: Colors.white,
                      fontSize: safeAreaWidth / 16,
                      bold: 700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: safeAreaWidth * 0.08,
                      left: safeAreaWidth * 0.08,
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        text.value = value;
                      },
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Normal",
                        fontVariations: const [FontVariation("wght", 700)],
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: safeAreaWidth / 20,
                      ),
                      decoration: InputDecoration(
                        errorText: errorText.value,
                        errorStyle: TextStyle(
                          fontFamily: "Normal",
                          fontVariations: const [FontVariation("wght", 400)],
                          color: Colors.red,
                          fontSize: safeAreaWidth / 30,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: "InstagramのユーザーIDを入力...",
                        hintStyle: TextStyle(
                          fontFamily: "Normal",
                          fontVariations: const [FontVariation("wght", 700)],
                          color: Colors.grey.withOpacity(0.5),
                          fontSize: safeAreaWidth / 25,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: safeAreaHeight * 0.04,
                    ),
                    child: GestureDetector(
                      onTap: () => text.value.isEmpty
                          ? null
                          : openURL(
                              url: "https://instagram.com/${text.value}",
                              onError: () =>
                                  errorText.value = "確認時に、エラーが発生しました。",
                            ),
                      child: Opacity(
                        opacity: text.value.isEmpty ? 0.3 : 1,
                        child: Container(
                          alignment: Alignment.center,
                          height: safeAreaHeight * 0.045,
                          width: safeAreaWidth * 0.4,
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: nText(
                            "アカウント確認する",
                            color: Colors.white,
                            fontSize: safeAreaWidth / 30,
                            bold: 700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Opacity(
                opacity: text.value.isEmpty ? 0.3 : 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: safeAreaHeight * 0.02),
                  child: bottomButton(
                    context: context,
                    isWhiteMainColor: true,
                    text: "完了",
                    onTap: () async {
                      if (isCheck()) {
                        dataUpLoad();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          loadinPage(
            context: context,
            isLoading: isLoading.value,
            text: null,
          ),
        ],
      ),
    );
  }
}
