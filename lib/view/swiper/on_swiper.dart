import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/swiper/message_sheet.dart';
import 'package:bubu_app/view_model/history_list.dart';
import 'package:bubu_app/view_model/loading_model.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/nearby_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:bubu_app/widget/home/swiper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnSwiper extends HookConsumerWidget {
  const OnSwiper({
    super.key,
    required this.isMyData,
    required this.data,
    required this.myData,
    required this.onNext,
    required this.onBack,
    required this.controller,
  });
  final UserData data;
  final UserData myData;
  final bool isMyData;
  final void Function() onNext;
  final void Function() onBack;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final imgIndex = useState<int>(data.isView ? data.imgList.length - 1 : 0);
    final message = useState<String?>(null);
    final isShowBottomSheet = useState<bool>(false);
    final nearbyList = ref.watch(nearbyUsersNotifierProvider);
    final historyNotifier = ref.watch(historyListNotifierProvider);
    final int historyNotifierWhen = historyNotifier.when(
      data: (value) => value.where((item) => item == data.id).length,
      error: (e, s) => 0,
      loading: () => 0,
    );
    final isNearby = (nearbyList?.data ?? []).contains(
      data.id,
    );

    Future<void> messageSend(String text) async {
      if (message.value == null) {
        message.value = text;
        await Future<void>.delayed(
          const Duration(seconds: 1, milliseconds: 500),
        );
        if (context.mounted) {
          message.value = null;
        }
      }
    }

    Future<void> sendMessage(String text) async {
      final loadingNotifier = ref.read(loadingNotifierProvider.notifier);
      final messageListNotifier =
          ref.read(messageListNotifierProvider.notifier);
      loadingNotifier.upData(
        loadinPage(context: context, isLoading: true, text: null),
      );
      final isSend = await messageListNotifier.sendMessage(
        myData.id,
        data,
        text,
      );
      if (isSend) {
        loadingNotifier.upData(null);
        messageSend(
          "メッセージを送信しました",
        );
      } else {
        loadingNotifier.upData(null);
        messageSend(
          "送信に失敗しました",
        );
      }
    }

    void isViweupData() {
      final setData = UserData(
        imgList: data.imgList,
        id: data.id,
        name: data.name,
        acquisitionAt: data.acquisitionAt,
        isGetData: data.isGetData,
        isView: true,
        birthday: data.birthday,
        family: data.family,
        instagram: data.instagram,
      );
      if (isMyData) {
        if (context.mounted) {
          final notifier = ref.read(
            userDataNotifierProvider.notifier,
          );
          notifier.isViewupData();
        }
      } else {
        if (context.mounted) {
          final notifier = ref.read(
            storyListNotifierProvider.notifier,
          );
          notifier.dataUpDate(setData);
        }
      }
    }

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (data.imgList.length == 1) {
            isViweupData();
          }
        });

        void listener() {
          try {
            if (controller!.offset > 0 && !isShowBottomSheet.value) {
              controller!.jumpTo(0);
              if (!isMyData && isNearby) {
                isShowBottomSheet.value = true;
                showModalBottomSheet<Widget>(
                  isScrollControlled: true,
                  context: context,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  builder: (context) => MessageBottomSheet(onTap: sendMessage),
                ).then((value) => isShowBottomSheet.value = false);
              }
            }
          } catch (e) {
            return;
          }
        }

        controller!.addListener(listener);
        return () {
          controller!.removeListener(listener);
        };
      },
      [],
    );
    return SafeArea(
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            Container(
              height: safeAreaHeight * 1,
              width: double.infinity,
              decoration: BoxDecoration(
                image: data.isGetData
                    ? DecorationImage(
                        image: MemoryImage(data.imgList[imgIndex.value]),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < 2; i++) ...{
                        Expanded(
                          child: GestureDetector(
                            onTap: context.mounted
                                ? () {
                                    if (i == 0) {
                                      if (imgIndex.value > 0) {
                                        imgIndex.value--;
                                      } else {
                                        onBack();
                                      }
                                    } else {
                                      if (imgIndex.value <
                                          data.imgList.length - 1) {
                                        imgIndex.value++;
                                      } else {
                                        onNext();
                                      }
                                    }
                                    if (imgIndex.value ==
                                        data.imgList.length - 1) {
                                      isViweupData();
                                    }
                                  }
                                : null,
                            child: Container(
                              height: double.infinity,
                              color: Colors.black.withOpacity(0),
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: safeAreaHeight * 0.1,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: safeAreaHeight * 0.02,
                          left: safeAreaWidth * 0.04,
                          right: safeAreaWidth * 0.04,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!data.isGetData) ...{
                              Container(
                                height: safeAreaHeight * 0.005,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            } else ...{
                              Row(
                                children: [
                                  for (int i = 0;
                                      i < data.imgList.length;
                                      i++) ...{
                                    Expanded(
                                      child: Opacity(
                                        opacity: i == imgIndex.value ? 1 : 0.4,
                                        child: Container(
                                          height: safeAreaHeight * 0.005,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (i < data.imgList.length - 1)
                                      SizedBox(width: safeAreaWidth * 0.01),
                                  },
                                ],
                              ),
                            },
                            SizedBox(height: safeAreaHeight * 0.01),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 0.8,
                                      ),
                                    ],
                                    size: safeAreaWidth / 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: safeAreaHeight * 0.02),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          height: safeAreaHeight * 0.17,
                          width: safeAreaWidth * 0.9,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: safeAreaWidth * 0.07,
                              left: safeAreaWidth * 0.07,
                              bottom: safeAreaHeight * 0.02,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: safeAreaHeight * 0.005,
                                          ),
                                          child: nText(
                                            isMyData
                                                ? "マイプロフィール"
                                                : isNearby
                                                    ? "このユーザーは付近にいます"
                                                    : "このユーザーは通信範囲外です",
                                            color: !isNearby || isMyData
                                                ? Colors.grey
                                                : greenColor,
                                            fontSize: safeAreaWidth / 40,
                                            bold: 700,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: safeAreaWidth * 0.75,
                                              ),
                                              child: nText(
                                                data.name,
                                                color: Colors.black,
                                                fontSize: safeAreaWidth / 23,
                                                bold: 700,
                                              ),
                                            ),
                                            nText(
                                              "（ ${getAgeFromDateString(data.birthday) ?? "未設定"} ）",
                                              color: Colors.black,
                                              fontSize: safeAreaWidth / 30,
                                              bold: 700,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: safeAreaHeight * 0.05,
                                  child: Row(
                                    children: [
                                      for (int i = 0; i < 2; i++) ...{
                                        Expanded(
                                          child: Opacity(
                                            opacity: i == 1 && !isNearby
                                                ? 0.2
                                                : isMyData
                                                    ? 0.2
                                                    : 1,
                                            child: Material(
                                              color: i == 0
                                                  ? blueColor2.withOpacity(0.2)
                                                  : blueColor2,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: InkWell(
                                                onTap: i == 1 && !isNearby
                                                    ? null
                                                    : isMyData
                                                        ? null
                                                        : () {
                                                            if (i == 0) {
                                                              showDialog<void>(
                                                                context:
                                                                    context,
                                                                builder: (
                                                                  BuildContext
                                                                      context,
                                                                ) =>
                                                                    Dialog(
                                                                  elevation: 0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  child:
                                                                      InstagramGetDialog(
                                                                    userData:
                                                                        data,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            if (i == 1) {
                                                              bottomSheet(
                                                                context,
                                                                page:
                                                                    MessageBottomSheet(
                                                                  onTap:
                                                                      sendMessage,
                                                                ),
                                                                isPOP: true,
                                                                isBackgroundColor:
                                                                    false,
                                                              );
                                                            }
                                                          },
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: safeAreaHeight * 0.05,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: nText(
                                                    i == 0
                                                        ? "Instagramアカウント"
                                                        : "メッセージを送信...",
                                                    color: i == 0
                                                        ? blueColor2
                                                        : Colors.white,
                                                    fontSize:
                                                        safeAreaWidth / 35,
                                                    bold: 700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (i == 0)
                                          SizedBox(
                                            width: safeAreaHeight * 0.02,
                                          ),
                                      },
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (historyNotifierWhen > 1) ...{
                    Align(
                      alignment: Alignment.topLeft,
                      child: EncountersWidget(
                        name: data.name,
                        count: historyNotifierWhen,
                      ),
                    ),
                  },
                  if (message.value != null) ...{
                    messageWidget(
                      context,
                      message.value!,
                      () => message.value = null,
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
    );
  }
}
