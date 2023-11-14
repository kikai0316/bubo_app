import 'dart:ui';
import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
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
      final dbupData =
          // ignore: avoid_bool_literals_in_conditional_expressions
          userData.imgList.isNotEmpty ? await userDataUpData(setData) : true;
      final iswWite = await writeUserData(setData);
      if (iswWite && dbupData) {
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
                        errorText.value = null;
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
                        isLoading.value = true;
                        final accountGet =
                            await getInstagramAccount(text.value);
                        if (accountGet != null) {
                          isLoading.value = false;
                          // ignore: use_build_context_synchronously
                          showDialog<void>(
                            context: context,
                            builder: (
                              BuildContext context,
                            ) =>
                                Dialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: instagramAccount(
                                context,
                                name: "${accountGet.username}",
                                img: "${accountGet.imgurl}",
                                onTap: () {
                                  Navigator.pop(context);
                                  dataUpLoad();
                                },
                              ),
                            ),
                          );
                        } else {
                          isLoading.value = false;
                          errorText.value = "アカウントが見つかりませんでした。";
                        }
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

Widget instagramAccount(
  BuildContext context, {
  required String name,
  required String img,
  required void Function() onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    height: safeAreaHeight * 0.4,
    width: safeAreaWidth * 0.9,
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.all(safeAreaWidth * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: safeAreaWidth * 0.2,
                    width: safeAreaWidth * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      image: DecorationImage(
                        image: NetworkImage(img),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  nText(
                    name,
                    color: Colors.black,
                    fontSize: safeAreaWidth / 20,
                    bold: 700,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              // top: safeAreaHeight * 0.01,
              bottom: safeAreaHeight * 0.01,
            ),
            child: dialogButton(
              context,
              title: "このアカウントで登録",
              onTap: onTap,
              backGroundColor: blueColor2,
              textColor: Colors.white,
              border: null,
            ),
          ),
          dialogButton(
            context,
            title: "とじる",
            onTap: () => Navigator.pop(context),
            backGroundColor: Colors.transparent,
            textColor: Colors.black,
            border: Border.all(),
          ),
        ],
      ),
    ),
  );
}
