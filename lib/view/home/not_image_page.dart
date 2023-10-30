import 'dart:typed_data';
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

class NotImgPage extends HookConsumerWidget {
  const NotImgPage({
    super.key,
    required this.userData,
  });
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final imgList = useState<List<Uint8List>>([]);
    final upLoadMesse = useState<String>("");
    final isLoading = useState<bool>(false);
    void showSnackbar() {
      errorSnackbar(
        context,
        text: "何らかの問題が発生しました。再試行してください。",
        padding: safeAreaHeight * 0.07,
      );
    }

    Future<void> dataUpLoad() async {
      isLoading.value = true;
      final imgItem = imgList.value.length;
      upLoadMesse.value = "アップロード中（ 0/$imgItem ）...";
      final isUpLoad = await upLoadImg(
        userData: userData,
        imgList: imgList.value,
        onStream: (int num) =>
            upLoadMesse.value = "アップロード中（ $num/$imgItem ）...",
      );
      if (isUpLoad) {
        final setData = UserData(
          imgList: imgList.value,
          id: userData.id,
          name: userData.name,
          birthday: userData.birthday,
          family: userData.family,
          instagram: userData.instagram,
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
          showSnackbar();
        }
      } else {
        isLoading.value = false;
        showSnackbar();
      }
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
                      top: safeAreaHeight * 0.03,
                      bottom: safeAreaHeight * 0.08,
                    ),
                    child: nText(
                      "プロフィール画像を\n1枚上選択してください。",
                      color: Colors.white,
                      fontSize: safeAreaWidth / 16,
                      bold: 700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: safeAreaHeight * 0.04),
                    child: nText(
                      "アップロード可能枚数：残り ${3 - (imgList.value.length)}枚",
                      color: Colors.grey,
                      fontSize: safeAreaWidth / 30,
                      bold: 500,
                    ),
                  ),
                  SizedBox(
                    width: safeAreaWidth * 1,
                    height: safeAreaHeight * 0.3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: safeAreaWidth * 0.03,
                            ),
                            child: Opacity(
                              opacity: imgList.value.length < 3 ? 1 : 0.3,
                              child: upWidget(
                                context,
                                isBlack: false,
                                onTap: () async {
                                  if (imgList.value.length < 3) {
                                    isLoading.value = true;
                                    await getMobileImage(
                                      onSuccess: (value) => imgList.value = [
                                        ...imgList.value,
                                        value,
                                      ],
                                      onError: () => errorSnackbar(
                                        context,
                                        text: "",
                                        padding: 0,
                                      ),
                                    );
                                    isLoading.value = false;
                                  }
                                },
                              ),
                            ),
                          ),
                          for (int i = 0; i < imgList.value.length; i++) ...{
                            imgWidget(
                              context,
                              img: imgList.value[i],
                              onTap: () {
                                imgList.value.removeAt(i);
                                imgList.value = [...imgList.value];
                              },
                            ),
                          },
                        ],
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
                opacity: imgList.value.isEmpty ? 0.3 : 1,
                child: bottomButton(
                  context: context,
                  isWhiteMainColor: true,
                  text: "アップロード",
                  onTap: () async {
                    if (imgList.value.isNotEmpty) {
                      dataUpLoad();
                    }
                  },
                ),
              ),
            ),
          ),
          loadinPage(
            context: context,
            isLoading: isLoading.value,
            text: upLoadMesse.value,
          ),
        ],
      ),
    );
  }
}

Widget upWidget(
  BuildContext context, {
  required void Function()? onTap,
  required bool isBlack,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Material(
    borderRadius: BorderRadius.circular(10),
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.topCenter,
        height: safeAreaHeight * 0.2,
        width: safeAreaWidth * 0.25,
        decoration: BoxDecoration(
          border: Border.all(
            color: isBlack ? Colors.black : Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: isBlack ? Colors.black : Colors.white,
              size: safeAreaWidth / 15,
            ),
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
              child: nText(
                "画像を追加",
                fontSize: safeAreaWidth / 30,
                color: isBlack ? Colors.black : Colors.white,
                bold: 700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget imgWidget(
  BuildContext context, {
  required void Function()? onTap,
  required Uint8List img,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.only(left: safeAreaWidth * 0.02),
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        alignment: Alignment.bottomRight,
        height: safeAreaHeight * 0.2,
        width: safeAreaWidth * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: MemoryImage(img),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(safeAreaWidth * 0.01),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              height: safeAreaHeight * 0.04,
              width: safeAreaHeight * 0.04,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: safeAreaWidth / 18,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
