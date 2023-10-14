import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/account.dart';
import 'package:bubu_app/view/home.dart';
import 'package:bubu_app/view/home/not_image_sheet.dart';
import 'package:bubu_app/view_model/loading_model.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:bubu_app/widget/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserApp extends HookConsumerWidget {
  const UserApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final loadingNotifier = ref.watch(loadingNotifierProvider);
    final selectInt = useState<int>(0);
    final notifier = ref.watch(userDataNotifierProvider);
    Future<void> showNotImgPage(BuildContext context, UserData userData) async {
      await Future<void>.delayed(const Duration(seconds: 1));
      // ignore: use_build_context_synchronously
      bottomSheet(
        context,
        isPOP: false,
        page: NotImgPage(
          userData: userData,
          onTap: () {
            final notifier = ref.read(userDataNotifierProvider.notifier);
            notifier.reLoad();
          },
        ),
        isBackgroundColor: true,
      );
    }

    final notifierWhen = notifier.when(
      data: (data) {
        if (data != null) {
          if (data.imgList.isEmpty) {
            showNotImgPage(context, data);
            return null;
          }
          return selectInt.value == 0
              ? HomePage(userData: data)
              : AccountPage(userData: data);
        } else {
          return errorWidget(
            context,
          );
        }
      },
      error: (e, s) => errorWidget(
        context,
      ),
      loading: () => loadinPage(isLoading: true, text: null, context: context),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: blackColor,
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: notifierWhen,
            bottomNavigationBar: Container(
              alignment: Alignment.topCenter,
              height: safeAreaHeight * 0.09,
              decoration: BoxDecoration(
                color: blackColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < pageList.length; i++) ...{
                    GestureDetector(
                      onTap: () => selectInt.value = i,
                      child: Opacity(
                        opacity: selectInt.value == i ? 1 : 0.2,
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black.withOpacity(0),
                          height: safeAreaHeight * 0.08,
                          width: safeAreaWidth * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                pageList[i].icon,
                                size: safeAreaWidth / 14,
                                color: Colors.white,
                              ),
                              nText(
                                pageList[i].name,
                                color: Colors.white.withOpacity(0.8),
                                fontSize: safeAreaWidth / 40,
                                bold: 400,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  }
                ],
              ),
            ),
          ),
          loadinPage(
            context: context,
            isLoading: loadingNotifier,
            text: "アップロード中...",
          )
        ],
      ),
    );
  }
}

final List<BottomData> pageList = [
  BottomData(
    Icons.home,
    "Home",
  ),
  BottomData(
    Icons.person,
    "Account",
  )
];

class BottomData {
  IconData icon;
  String name;
  BottomData(
    this.icon,
    this.name,
  );
}
