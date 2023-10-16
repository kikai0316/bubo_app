import 'package:bubu_app/component/component.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/swiper.dart';
import 'package:bubu_app/widget/home/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.userData});
  final UserData userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final deviceList = useState<List<UserData>>([
      userData,
      userData,
      userData,
      userData,
    ]);
    // final transmissionHistory = useState<List<String>>([]);
    // final nearbyService = NearbyService();

    // Future<void> sendImageToPeer(String deviceId) async {
    //   final String encodedImage = base64Encode(userData.imgList.first);
    //   final Map<String, dynamic> setImgData = <String, dynamic>{
    //     'type': 'image',
    //     'id': userData.id,
    //     'name': userData.name,
    //     'birthday': userData.birthday,
    //     'img': encodedImage
    //   };
    //   nearbyService.sendMessage(deviceId, jsonEncode(setImgData));
    // }

    // Future<void> ss() async {
    //   nearbyService.stateChangedSubscription(
    //     callback: (devicesList) async {
    //       for (final device in devicesList) {
    //         if (device.state == SessionState.notConnected) {
    //           try {
    //             nearbyService.invitePeer(
    //               deviceID: device.deviceId,
    //               deviceName: device.deviceName,
    //             );
    //           } catch (e) {
    //             return;
    //           }
    //         }
    //         if (device.state == SessionState.connected) {
    //           if (!transmissionHistory.value.contains(device.deviceId)) {
    //             try {
    //               await sendImageToPeer(device.deviceId);
    //               transmissionHistory.value = [
    //                 ...transmissionHistory.value,
    //                 device.deviceId
    //               ];
    //             } catch (e) {
    //               return;
    //             }
    //           }
    //         }
    //       }
    //     },
    //   );
    // }

    // void setupReceivedDataSubscription() {
    //   nearbyService.dataReceivedSubscription(
    //     callback: (dynamic data) {
    //       final receivedData =
    //           // ignore: avoid_dynamic_calls
    //           jsonDecode(data['message'] as String) as Map<String, dynamic>;
    //       if (receivedData["type"] == 'image') {
    //         final imgListDecode = (receivedData['img'] as List<dynamic>)
    //             .map(
    //               (dynamic base64String) =>
    //                   base64Decode(base64String as String),
    //             )
    //             .toList();
    //         final String getId = receivedData['id'] as String;
    //         final String getName = receivedData['name'] as String;
    //         final UserData setData = UserData(
    //           imgList: imgListDecode,
    //           id: getId,
    //           name: getName,
    //           birthday: "",
    //           family: "",
    //         );
    //         deviceList.value = [...deviceList.value, setData];
    //       }
    //     },
    //   );
    // }

    // Future<void> initNearbyService() async {
    //   final String encodedImage = base64Encode(userData.imgList.first);
    //   await nearbyService.init(
    //     serviceType: 'bobo',
    //     deviceName: "${userData.id}",
    //     strategy: Strategy.P2P_CLUSTER,
    //     callback: (bool isRunning) async {
    //       if (isRunning) {
    //         try {
    //           await nearbyService.stopAdvertisingPeer();
    //           await nearbyService.stopBrowsingForPeers();
    //           await Future<void>.delayed(const Duration(microseconds: 200));
    //           await nearbyService.startAdvertisingPeer();
    //           await nearbyService.startBrowsingForPeers();
    //           await Future<void>.delayed(const Duration(microseconds: 200));
    //           ss();
    //           setupReceivedDataSubscription();
    //         } catch (e) {
    //           return;
    //         }
    //       }
    //     },
    //   );
    // }

    // useEffect(
    //   () {
    //     // initNearbyService();
    //     return null;
    //   },
    //   [],
    // );

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      appBar: appberWithLogo(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: safeAreaWidth * 0.02,
                ),
                for (int i = 0; i < deviceList.value.length; i++) ...{
                  OnStory(
                    // key: ValueKey(" ${deviceList.value[i]} $i"),
                    isMyData: i == 0,
                    data: deviceList.value[i],
                    index: i,
                    onTap: () {
                      Navigator.push<Widget>(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => SwiperPage(
                            index: i,
                            storyList: deviceList.value,
                          ),
                        ),
                      );
                    },
                  )
                }
              ],
            ),
          ),
          line(
            context,
            top: safeAreaHeight * 0.01,
            bottom: safeAreaHeight * 0.01,
          ),
          // Align(
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: safeAreaHeight * 0.01),
          //     child: nText("メッセージ",
          //         color: Colors.white, fontSize: safeAreaWidth / 20, bold: 700),
          //   ),
          // ),
          for (int i = 0; i < 2; i++) ...{
            if (i != 0) ...{
              line(context, top: 0, bottom: 0),
            },
            onMessage(context, userData)
          },
          // SizedBox(
          //   height: safeAreaHeight * 0.11,
          // ),
          // for (int i = 0; i < transmissionHistory.value.length; i++) ...{
          //   Text(
          //     transmissionHistory.value[i],
          //     style: const TextStyle(color: Colors.red),
          //   )
          // },
          // bottomButton(
          //   context: context,
          //   isWhiteMainColor: true,
          //   text: "削除",
          //   onTap: () async {},
          // ),
          // SizedBox(
          //   height: safeAreaHeight * 0.11,
          // ),
        ],
      ),
    );
  }

  PreferredSizeWidget appberWithLogo(BuildContext context) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: safeAreaHeight * 0.1,
            width: safeAreaWidth * 0.22,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/logo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              nText(
                "今日すれ違った数：1人",
                color: Colors.white,
                fontSize: safeAreaWidth / 35,
                bold: 500,
              )
            ],
          )
        ],
      ),
    );
  }
}
