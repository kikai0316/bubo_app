import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/not_image_page.dart';
import 'package:bubu_app/widget/app_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImgUpLoadPage extends HookConsumerWidget {
  const ImgUpLoadPage({super.key, required this.userData, required this.onTap});
  final UserData userData;
  final void Function(List<Uint8List>) onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final imgList = useState<List<Uint8List>>([...userData.imgList]);
    final isLoading = useState<bool>(false);

    return SizedBox(
      height: safeAreaHeight * 0.9,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBarWidget(
              context,
              "UpLoad Image!",
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
                            Padding(
                              padding: EdgeInsets.only(
                                top: safeAreaHeight * 0.01,
                                bottom: safeAreaHeight * 0.06,
                              ),
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
                                        opacity:
                                            imgList.value.length < 3 ? 1 : 0.3,
                                        child: upWidget(
                                          context,
                                          isBlack: true,
                                          onTap: () async {
                                            if (imgList.value.length < 3) {
                                              isLoading.value = true;
                                              await getMobileImage(
                                                onSuccess: (value) =>
                                                    imgList.value = [
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
                                    for (int i = 0;
                                        i < imgList.value.length;
                                        i++) ...{
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
                      child: Padding(
                        padding: EdgeInsets.only(bottom: safeAreaHeight * 0.01),
                        child: Opacity(
                          opacity: imgList.value.isEmpty ? 0.3 : 1,
                          child: bottomButton(
                            context: context,
                            isWhiteMainColor: false,
                            text: "アップロード",
                            onTap: () async {
                              if (imgList.value.isNotEmpty) {
                                onTap(imgList.value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          loadinPage(context: context, isLoading: isLoading.value, text: null),
        ],
      ),
    );
  }
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
