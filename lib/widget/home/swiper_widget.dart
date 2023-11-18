import 'dart:ui';

import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/ticket_list.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/intersitital_ad.dart';
import 'package:bubu_app/view_model/ticket_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

int? getAgeFromDateString(String dateString) {
  if (dateString.length != 8) {
    return null;
  }
  final year = int.parse(dateString.substring(0, 4));
  final month = int.parse(dateString.substring(4, 6));
  final day = int.parse(dateString.substring(6, 8));
  final birthDate = DateTime(year, month, day);
  return calculateAge(birthDate);
}

int calculateAge(DateTime birthDate) {
  final currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  if (currentDate.month < birthDate.month ||
      (currentDate.month == birthDate.month &&
          currentDate.day < birthDate.day)) {
    age--;
  }
  return age;
}

Widget messageWidget(BuildContext context, String text, void Function() onTap) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: double.infinity,
      color: Colors.black.withOpacity(0.5),
      child: Container(
        alignment: Alignment.center,
        height: safeAreaHeight * 0.06,
        width: safeAreaWidth * 0.5,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: nText(
          text,
          color: Colors.white,
          fontSize: safeAreaWidth / 28,
          bold: 700,
        ),
      ),
    ),
  );
}

class EncountersWidget extends HookConsumerWidget {
  const EncountersWidget({super.key, required this.count, required this.name});
  final int count;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    useEffect(
      () {
        encounterSnackbar(name: name, count: count);
        return null;
      },
      [],
    );
    return Padding(
      padding: EdgeInsets.only(
        top: safeAreaHeight * 0.04,
        left: safeAreaWidth * 0.03,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: greenColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: safeAreaHeight * 0.006,
            bottom: safeAreaHeight * 0.006,
            left: safeAreaWidth * 0.03,
            right: safeAreaWidth * 0.03,
          ),
          child: nText(
            "$count回目の出会い",
            color: Colors.white,
            fontSize: safeAreaWidth / 28,
            bold: 700,
          ),
        ),
      ),
    );
  }
}

class InstagramGetDialog extends HookConsumerWidget {
  const InstagramGetDialog({
    super.key,
    required this.userData,
  });
  final UserData userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final isCopy = useState<bool>(false);
    final adNotifire = ref.watch(interstitialAdNotifierProvider);
    final notifier = ref.watch(ticketListNotifierProvider);
    final isScreen = useState<bool?>(null);
    final timeText = useState<String?>(null);
    final notifierWhen = notifier.when(
      data: (data) {
        if (isScreen.value == null) {
          final notifier = ref.read(ticketListNotifierProvider.notifier);
          notifier.deleteAD();
          isScreen.value = containsId(userData.id, data);
        }

        return data;
      },
      error: (e, s) => const TicketList(free: [], ad: []),
      loading: () => const TicketList(free: [], ad: []),
    );

    Future<void> copy() async {
      if (!isCopy.value) {
        isCopy.value = true;
        await Future<void>.delayed(
          const Duration(seconds: 1, milliseconds: 500),
        );
        if (context.mounted) {
          isCopy.value = false;
        }
      }
    }

    Future<void> getInstagramToNext(bool isFree) async {
      final setData = TicketList(
        free: isFree
            ? [
                ...notifierWhen.free,
                TicketData(
                  id: userData.id,
                  acquisitionAt: DateTime.now(),
                ),
              ]
            : notifierWhen.free,
        ad: isFree
            ? notifierWhen.ad
            : [
                ...notifierWhen.ad,
                TicketData(
                  id: userData.id,
                  acquisitionAt: DateTime.now(),
                ),
              ],
      );
      final notifier = ref.read(ticketListNotifierProvider.notifier);
      notifier.addData(setData);
      HapticFeedback.vibrate();
      isScreen.value = true;
    }

    final adNotifireWhen = adNotifire.when(
      data: (data) => data == null
          ? adLoading(context)
          : Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.02),
              child: dialogButton(
                context,
                title: "広告を見て取得",
                onTap: () {
                  final readNotifierProvider =
                      ref.read(interstitialAdNotifierProvider.notifier);
                  data.fullScreenContentCallback = FullScreenContentCallback(
                    onAdDismissedFullScreenContent: (ad) {
                      readNotifierProvider.dispose();
                      getInstagramToNext(false);
                    },
                    onAdFailedToShowFullScreenContent: (ad, error) {
                      readNotifierProvider.dispose();
                    },
                  );
                  interstitialAd.show();
                },
                backGroundColor: Colors.transparent,
                textColor: blueColor2,
                border: Border.all(color: blueColor2),
              ),
            ),
      error: (e, s) => Padding(
        padding: EdgeInsets.only(top: safeAreaHeight * 0.02),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: safeAreaHeight * 0.005),
              child: nText(
                "広告の取得にエラーが発生しました",
                color: Colors.red,
                fontSize: safeAreaWidth / 35,
                bold: 700,
              ),
            ),
            dialogButton(
              context,
              title: "広告データ再取得",
              onTap: () {
                final readNotifire =
                    ref.read(interstitialAdNotifierProvider.notifier);
                readNotifire.dispose();
              },
              backGroundColor: Colors.transparent,
              textColor: Colors.red,
              border: Border.all(color: Colors.red),
            ),
          ],
        ),
      ),
      loading: () => adLoading(context),
    );
    useEffect(
      () {
        var cancelled = false;
        final bool isTime = timeText.value == null &&
            notifierWhen.free.isNotEmpty &&
            isScreen.value == false;
        if (isTime) {
          Future(() async {
            while (isTime && !cancelled) {
              if (context.mounted) {
                if (notifierWhen.free.isNotEmpty &&
                    !cancelled &&
                    isScreen.value == false) {
                  final String? getTime =
                      getRemainingTime(notifierWhen.free.first.acquisitionAt);
                  if (getTime == null) {
                    final setlist = [...notifierWhen.free];
                    setlist.removeAt(0);
                    final setData = TicketList(
                      free: setlist,
                      ad: notifierWhen.ad,
                    );
                    final notifier =
                        ref.read(ticketListNotifierProvider.notifier);
                    notifier.addData(setData);
                    timeText.value = null;
                  } else {
                    timeText.value = getTime;
                  }
                }
              }
              await Future<void>.delayed(const Duration(seconds: 1));
            }
          });
        }
        return () {
          cancelled = true;
        };
      },
      [notifierWhen],
    );

    return Container(
      height: safeAreaHeight * 0.33,
      width: safeAreaWidth * 0.9,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(safeAreaWidth * 0.04),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isScreen.value != true) ...{
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          nText(
                            "Instagramを取得しますか？",
                            color: Colors.black,
                            fontSize: safeAreaWidth / 20,
                            bold: 700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  nText(
                    "チケット：${2 - notifierWhen.free.length} 枚",
                    color: blueColor2,
                    fontSize: safeAreaWidth / 27,
                    bold: 700,
                  ),
                  if (timeText.value != null) ...{
                    nText(
                      "チケット回復まで残り ${timeText.value}",
                      color: Colors.grey,
                      fontSize: safeAreaWidth / 40,
                      bold: 700,
                    ),
                  },
                  adNotifireWhen,
                  Padding(
                    padding: EdgeInsets.only(top: safeAreaHeight * 0.02),
                    child: Opacity(
                      opacity: notifierWhen.free.length > 1 ? 0.3 : 1,
                      child: dialogButton(
                        context,
                        title: "チケットで取得",
                        onTap: () {
                          if (notifierWhen.free.length < 2) {
                            getInstagramToNext(true);
                          }
                        },
                        backGroundColor: blueColor2,
                        textColor: Colors.white,
                        border: null,
                      ),
                    ),
                  ),
                } else ...{
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: safeAreaWidth * 0.6,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    userData.instagram,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: "Normal",
                                      fontVariations: const [
                                        FontVariation("wght", 700),
                                      ],
                                      color: Colors.black,
                                      fontSize: safeAreaWidth / 16,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: safeAreaWidth * 0.03),
                                child: GestureDetector(
                                  onTap: isCopy.value
                                      ? null
                                      : () async {
                                          final data = ClipboardData(
                                            text: userData.instagram,
                                          );
                                          await Clipboard.setData(data);
                                          copy();
                                        },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: safeAreaHeight * 0.035,
                                    width: safeAreaHeight * 0.035,
                                    decoration: BoxDecoration(
                                      color: isCopy.value
                                          ? greenColor
                                          : Colors.black,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      isCopy.value
                                          ? Icons.done
                                          : Icons.content_copy,
                                      color: Colors.white,
                                      size: safeAreaWidth / 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: safeAreaHeight * 0.01),
                    child: dialogButton(
                      context,
                      title: "Instagramアプリを開く",
                      onTap: () => openURL(
                        url: "https://instagram.com/${userData.instagram}",
                        onError: null,
                      ),
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
                },
              ],
            ),
            if (isScreen.value != true) ...{
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: safeAreaWidth / 13,
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }

  bool containsId(String targetId, TicketList list) {
    if (list.free.any((ticket) => ticket.id == targetId)) {
      return true;
    }
    if (list.ad.any((ticket) => ticket.id == targetId)) {
      return true;
    }
    return false;
  }

  String? getRemainingTime(DateTime specificDateTime) {
    final DateTime targetTime = specificDateTime.add(const Duration(hours: 12));
    final DateTime currentTime = DateTime.now();
    if (targetTime.isBefore(currentTime)) {
      return null;
    }
    final Duration diff = targetTime.difference(currentTime);
    final int hours = diff.inHours;
    final int minutes = diff.inMinutes % 60;
    final int seconds = diff.inSeconds % 60;
    return "$hours時間$minutes分$seconds秒";
  }

  Widget adLoading(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    return Padding(
      padding: EdgeInsets.only(top: safeAreaHeight * 0.02),
      child: SizedBox(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.3,
              child: dialogButton(
                context,
                title: "広告を見て取得",
                onTap: () {},
                backGroundColor: Colors.transparent,
                textColor: blueColor2,
                border: Border.all(color: blueColor2),
              ),
            ),
            CupertinoActivityIndicator(
              color: Colors.black,
              radius: safeAreaHeight * 0.015,
            ),
          ],
        ),
      ),
    );
  }
}
