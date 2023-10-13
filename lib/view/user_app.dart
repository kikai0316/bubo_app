import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/account.dart';
import 'package:bubu_app/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserApp extends HookConsumerWidget {
  const UserApp({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final selectInt = useState<int>(0);
    final List<BottomData> pageList = [
      BottomData(
        Icons.home,
        "Home",
        HomePage(
          userData: userData,
        ),
      ),
      BottomData(Icons.person, "Account", const AccountPage())
    ];
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: pageList[selectInt.value].page,
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
        // loadinPage(context: context, isLoading: isLodaing, text: null)
      ],
    );
  }
}

class BottomData {
  IconData icon;
  String name;
  Widget page;
  BottomData(this.icon, this.name, this.page);
}
