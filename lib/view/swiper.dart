import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/view/swiper/on_swiper.dart';
import 'package:bubu_app/view_model/loading_model.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ScrollController scrollController = ScrollController();
final CarouselSliderController controller = CarouselSliderController();

class SwiperPage extends HookConsumerWidget {
  const SwiperPage({
    super.key,
    required this.index,
    required this.nearbyList,
    required this.isMyData,
    required this.myUserData,
  });
  final int index;
  final bool isMyData;
  final List<String> nearbyList;
  final UserData myUserData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState<int>(index + 1);
    final isMove = useState<bool>(false);
    final scrollBack = useState<double>(0);
    final storyList = ref.watch(storyListNotifierProvider);
    final List<UserData> storyNotifier = storyList.when(
      data: (data) =>
          data.where((userData) => nearbyList.contains(userData.id)).toList(),
      error: (e, s) => [],
      loading: () => [],
    );
    final loadingNotifier = ref.watch(loadingNotifierProvider);
    bool isNotScreen(int index) {
      if (index == 0 || index == storyNotifier.length + 1) {
        return true;
      } else {
        return false;
      }
    }

    Future<void> moveAnimation() async {
      isMove.value = true;
      await Future<void>.delayed(const Duration(milliseconds: 300));
      isMove.value = false;
    }

    Future<void> fetchAndUpdate(int index) async {
      final getImg = await imgOtherGet(storyNotifier[index]);
      if (getImg != null && !storyNotifier[index].isGetData) {
        if (context.mounted) {
          final notifier = ref.read(storyListNotifierProvider.notifier);
          notifier.dataUpDate(getImg);
        }
      }
    }

    Future<void> getOthers(int dataIndex) async {
      if (!storyNotifier[dataIndex].isGetData) {
        fetchAndUpdate(dataIndex);
      }
      if (dataIndex + 1 < storyNotifier.length &&
          !storyNotifier[dataIndex + 1].isGetData) {
        fetchAndUpdate(dataIndex + 1);
      }
      if (dataIndex - 1 >= 0 && !storyNotifier[dataIndex - 1].isGetData) {
        fetchAndUpdate(dataIndex - 1);
      } else if (dataIndex + 2 < storyNotifier.length &&
          !storyNotifier[dataIndex + 2].isGetData) {
        fetchAndUpdate(dataIndex + 2);
      }
    }

    useEffect(
      () {
        getOthers(index);
        void listener() {
          try {
            if (scrollController.offset < -60) {
              if (scrollBack.value > scrollController.offset) {
                scrollBack.value = scrollController.offset;
              } else {
                Navigator.pop(context);
                scrollController.removeListener(listener);
              }
            }
          } catch (e) {
            return;
          }
        }

        scrollController.addListener(listener);
        return () {
          scrollController.removeListener(listener);
        };
      },
      [],
    );

    return Hero(
      tag: pageIndex.value == 0
          ? storyNotifier[0].id
          : pageIndex.value == storyNotifier.length + 1
              ? storyNotifier[storyNotifier.length - 1].id
              : storyNotifier[pageIndex.value - 1].id,
      child: Stack(
        children: [
          Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: CarouselSlider.builder(
              controller: controller,
              initialPage: index + 1,
              onSlideChanged: (value) async {
                if (isNotScreen(value)) {
                  Navigator.pop(context);
                } else {
                  getOthers(value - 1);
                }
                pageIndex.value = value;
              },
              slideTransform: const CubeTransform(),
              itemCount: storyNotifier.length + 2,
              slideBuilder: (index) {
                if (isNotScreen(index)) {
                  return Container(
                    height: double.infinity,
                    color: Colors.black,
                  );
                } else {
                  return storyNotifier.isEmpty
                      ? Container()
                      : OnSwiper(
                          myData: myUserData,
                          isMyData: isMyData,
                          controller: scrollController,
                          data: storyNotifier[index - 1],
                          onNext: () {
                            moveAnimation();
                            controller.nextPage(
                              const Duration(milliseconds: 300),
                            );
                          },
                          onBack: () {
                            if (index != 1) {
                              moveAnimation();
                              controller.previousPage(
                                const Duration(milliseconds: 300),
                              );
                            }
                          },
                        );
                }
              },
            ),
          ),
          Visibility(
            visible: isMove.value,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0),
            ),
          ),
          if (loadingNotifier != null) ...{
            loadingNotifier,
          },
        ],
      ),
    );
  }
}
