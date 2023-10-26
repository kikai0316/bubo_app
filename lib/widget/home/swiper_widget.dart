import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnSwiper extends HookConsumerWidget {
  const OnSwiper({
    super.key,
    required this.isMyData,
    required this.isNearby,
    required this.data,
    required this.onNext,
    required this.onBack,
  });
  final UserData data;
  final bool isMyData;
  final bool isNearby;
  final void Function() onNext;
  final void Function() onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final imgIndex = useState<int>(data.isView ? data.imgList.length - 1 : 0);
    return Container(
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
                              if (imgIndex.value < data.imgList.length - 1) {
                                imgIndex.value++;
                                if (imgIndex.value == data.imgList.length - 1) {
                                  final setData = UserData(
                                    imgList: data.imgList,
                                    id: data.id,
                                    name: data.name,
                                    acquisitionAt: data.acquisitionAt,
                                    isGetData: data.isGetData,
                                    isView: true,
                                    birthday: data.birthday,
                                    family: data.family,
                                  );
                                  if (isMyData) {
                                    final notifier = ref.read(
                                      userDataNotifierProvider.notifier,
                                    );
                                    notifier.isViewupData();
                                  } else {
                                    final notifier = ref.read(
                                      storyListNotifierProvider.notifier,
                                    );
                                    notifier.dataUpDate(setData);
                                  }
                                }
                              } else {
                                onNext();
                              }
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
                    Colors.black.withOpacity(1),
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
                          for (int i = 0; i < data.imgList.length; i++) ...{
                            Expanded(
                              child: Opacity(
                                opacity: i == imgIndex.value ? 1 : 0.4,
                                child: Container(
                                  height: safeAreaHeight * 0.005,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
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
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SizedBox(
                        width: safeAreaWidth * 1,
                        height: safeAreaHeight * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: safeAreaWidth * 0.7,
                                  ),
                                  child: nTextWithShadow(
                                    data.name,
                                    color: Colors.white,
                                    fontSize: safeAreaWidth / 16,
                                    bold: 700,
                                  ),
                                ),
                                nTextWithShadow(
                                  "（ ${getAgeFromDateString(data.birthday) ?? "未設定"} ）",
                                  color: Colors.white,
                                  fontSize: safeAreaWidth / 25,
                                  bold: 700,
                                ),
                              ],
                            ),
                            GestureDetector(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isMyData)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(safeAreaWidth * 0.03),
                child: Container(
                  decoration: BoxDecoration(
                    color: isNearby ? greenColor : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: safeAreaHeight * 0.006,
                      bottom: safeAreaHeight * 0.006,
                      left: safeAreaWidth * 0.04,
                      right: safeAreaWidth * 0.04,
                    ),
                    child: nText(
                      isNearby ? "付近にいます" : "付近にいません",
                      color: isNearby
                          ? Colors.white
                          : Colors.black.withOpacity(0.5),
                      fontSize: safeAreaWidth / 30,
                      bold: 700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

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
}

Widget messageWidget(BuildContext context, String text) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final safeAreaHeight = safeHeight(context);
  return Container(
    alignment: Alignment.center,
    height: double.infinity,
    color: Colors.black.withOpacity(0.2),
    child: Container(
      alignment: Alignment.center,
      height: safeAreaHeight * 0.08,
      width: safeAreaWidth * 0.5,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: nText(
        text,
        color: Colors.white,
        fontSize: safeAreaWidth / 30,
        bold: 500,
      ),
    ),
  );
}
