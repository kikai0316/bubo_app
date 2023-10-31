import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/constant/dummy_data.dart';
import 'package:bubu_app/model/ticket_list.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/ticket_list.dart';
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

// ignore: must_be_immutable
class InstagramGetDialog extends HookConsumerWidget {
  InstagramGetDialog({
    super.key,
    required this.userData,
  });
  final UserData userData;
  InterstitialAd? interstitialAd;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final isCopy = useState<bool>(false);
    final notifier = ref.watch(ticketListNotifierProvider);
    final isScreen = useState<bool>(false);
    final isSetAd = useState<bool>(false);
    final timeText = useState<String?>(null);
    final isInitIntersititalAdCalled = useState<bool>(false);
    final notifierWhen = notifier.when(
      data: (data) {
        isScreen.value = containsId(userData.id, data);
        return data;
      },
      error: (e, s) => const TicketList(free: [], ad: []),
      loading: () => const TicketList(free: [], ad: []),
    );
    final titleText = [
      "広告を見て取得",
      "チケットで取得",
    ];
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

    void getInstagramToNext() {
      final setData = TicketList(
        free: [
          ...notifierWhen.free,
          TicketData(
            id: userData.id,
            acquisitionAt: DateTime.now(),
          ),
        ],
        ad: notifierWhen.ad,
      );
      final notifier = ref.read(ticketListNotifierProvider.notifier);
      notifier.addData(setData);
      isScreen.value = true;
    }

    void initIntersititalAd() {
      InterstitialAd.load(
        adUnitId: textADID,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            isSetAd.value = true;
            interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                getInstagramToNext();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
              },
            );
          },
          onAdFailedToLoad: (errror) {
            interstitialAd!.dispose();
          },
        ),
      );
    }

    useEffect(
      () {
        if (!isInitIntersititalAdCalled.value) {
          initIntersititalAd();
          isInitIntersititalAdCalled.value = true;
        }
        var cancelled = false;
        final bool isTime = timeText.value == null &&
            notifierWhen.free.isNotEmpty &&
            !isScreen.value;
        if (isTime) {
          Future(() async {
            while (isTime && !cancelled) {
              if (context.mounted) {
                if (notifierWhen.free.isNotEmpty &&
                    !cancelled &&
                    !isScreen.value) {
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
                if (!isScreen.value) ...{
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
                  for (int i = 0; i < 2; i++) ...{
                    Padding(
                      padding: EdgeInsets.only(top: safeAreaHeight * 0.02),
                      child: Opacity(
                        opacity:
                            i == 1 && notifierWhen.free.length > 1 ? 0.3 : 1,
                        child: button(
                          context,
                          title: titleText[i],
                          onTap: () {
                            if (i == 0) {
                              try {
                                if (isSetAd.value) {
                                  interstitialAd!.show();
                                }
                              } catch (e) {
                                return;
                              }
                            }
                            if (i == 1 && notifierWhen.free.length < 2) {
                              getInstagramToNext();
                            }
                          },
                          backGroundColor:
                              i == 0 ? Colors.transparent : blueColor2,
                          textColor: i == 0 ? blueColor2 : Colors.white,
                          border: i == 0 ? Border.all(color: blueColor2) : null,
                        ),
                      ),
                    ),
                  },
                } else ...{
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: nText(
                              userData.instagram,
                              color: Colors.black,
                              fontSize: safeAreaWidth / 16,
                              bold: 700,
                            ),
                          ),
                          Container(
                            height: safeAreaHeight * 0.06,
                            alignment: Alignment.bottomCenter,
                            child: isCopy.value
                                ? nText(
                                    "コピー完了!!",
                                    color: Colors.green,
                                    fontSize: safeAreaWidth / 25,
                                    bold: 700,
                                  )
                                : Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: isCopy.value
                                          ? null
                                          : () async {
                                              final data = ClipboardData(
                                                text: userData.instagram,
                                              );
                                              await Clipboard.setData(data);
                                              copy();
                                            },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: safeAreaHeight * 0.035,
                                        width: safeAreaWidth * 0.3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: safeAreaWidth * 0.02,
                                              ),
                                              child: Icon(
                                                Icons.content_copy,
                                                color: Colors.white,
                                                size: safeAreaWidth / 25,
                                              ),
                                            ),
                                            nText(
                                              "コピーする",
                                              color: Colors.white,
                                              fontSize: safeAreaWidth / 35,
                                              bold: 700,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  button(
                    context,
                    title: "とじる",
                    onTap: () {
                      // final notifier =
                      //     ref.read(ticketListNotifierProvider.notifier);
                      // notifier.addData(TicketList(free: [], ad: []));
                    },
                    // =>
                    // Navigator.pop(context),
                    backGroundColor: Colors.transparent,
                    textColor: Colors.black,
                    border: Border.all(),
                  ),
                },
              ],
            ),
            if (!isScreen.value) ...{
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

  Widget button(
    BuildContext context, {
    required String title,
    required Color backGroundColor,
    required Color textColor,
    required BoxBorder? border,
    required void Function() onTap,
  }) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    return Material(
      color: backGroundColor,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          alignment: Alignment.center,
          height: safeAreaHeight * 0.055,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(50),
          ),
          child: nText(
            title,
            color: textColor,
            fontSize: safeAreaWidth / 30,
            bold: 700,
          ),
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
}
