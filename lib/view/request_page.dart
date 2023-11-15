import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/notification_utility.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/user_app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestNotificationsPage extends HookConsumerWidget {
  const RequestNotificationsPage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: safeAreaHeight * 0.1),
                      child: nText(
                        "通知を許可しますか？",
                        color: Colors.white,
                        fontSize: safeAreaWidth / 15,
                        bold: 500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: safeAreaHeight * 0.05,
                        bottom: safeAreaHeight * 0.11,
                      ),
                      child: nText(
                        "アプリからの通知を受け取るためには、\n通知を許可してください。",
                        color: Colors.grey,
                        fontSize: safeAreaWidth / 25,
                        bold: 500,
                      ),
                    ),
                    SizedBox(
                      height: safeAreaHeight * 0.25,
                      width: safeAreaWidth * 0.8,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: safeAreaHeight * 0.21,
                            width: safeAreaWidth * 0.8,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: safeAreaHeight * 0.14,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: nText(
                                    "BUBUは通知を送信します。\nよろしいですか？",
                                    color: blackColor.withOpacity(0.9),
                                    fontSize: safeAreaWidth / 23,
                                    bold: 700,
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        for (int i = 0; i < 2; i++) ...{
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: double.infinity,
                                              child: nText(
                                                i == 0 ? "許可しない" : "許可",
                                                color:
                                                    blackColor.withOpacity(0.4),
                                                fontSize: safeAreaWidth / 26,
                                                bold: 700,
                                              ),
                                            ),
                                          ),
                                          if (i == 0)
                                            Container(
                                              width: 0.5,
                                              height: double.infinity,
                                              color: Colors.grey,
                                            ),
                                        },
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: safeAreaWidth * 0.08,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: safeAreaHeight * 0.11,
                                height: safeAreaHeight * 0.11,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: blueColor2,
                                      blurRadius: 20,
                                      spreadRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: nText(
                                  "許可",
                                  color: blueColor2,
                                  fontSize: safeAreaWidth / 19,
                                  bold: 700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: safeAreaHeight * 0.25,
                  bottom: safeAreaHeight * 0.02,
                ),
                child: shadowButton(
                  context,
                  text: "通知をONにする",
                  onTap: () async {
                    await NotificationClass().requestPermissions();
                    // ignore: use_build_context_synchronously
                    screenTransitionNormal(context, const UserApp(initPage: 0));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
