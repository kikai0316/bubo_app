import 'dart:convert';
import 'package:bubu_app/component/button.dart';
import 'package:bubu_app/component/component.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/home/story.dart';
import 'package:bubu_app/widget/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
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
    ]);
    final transmissionHistory = useState<List<String>>([]);
    final nearbyService = NearbyService();

    Future<void> sendImageToPeer(String deviceId) async {
      final toBase64 =
          userData.imgList.map((data) => base64Encode(data)).toList();
      final Map<String, dynamic> setImgData = <String, dynamic>{
        'type': 'image',
        'id': userData.id,
        'name': userData.name,
        'img': toBase64
      };
      nearbyService.sendMessage(deviceId, jsonEncode(setImgData));
    }

    Future<void> ss() async {
      nearbyService.stateChangedSubscription(
        callback: (devicesList) async {
          for (final device in devicesList) {
            if (device.state == SessionState.notConnected) {
              try {
                nearbyService.invitePeer(
                  deviceID: device.deviceId,
                  deviceName: device.deviceName,
                );
              } catch (e) {
                return;
              }
            }
            if (device.state == SessionState.connected) {
              if (!transmissionHistory.value.contains(device.deviceId)) {
                try {
                  await sendImageToPeer(device.deviceId);
                  transmissionHistory.value = [
                    ...transmissionHistory.value,
                    device.deviceId
                  ];
                } catch (e) {
                  return;
                }
              }
            }
          }
        },
      );
    }

    void setupReceivedDataSubscription() {
      nearbyService.dataReceivedSubscription(
        callback: (dynamic data) {
          final receivedData =
              // ignore: avoid_dynamic_calls
              jsonDecode(data['message'] as String) as Map<String, dynamic>;
          if (receivedData["type"] == 'image') {
            final imgListDecode = (receivedData['img'] as List<dynamic>)
                .map(
                  (dynamic base64String) =>
                      base64Decode(base64String as String),
                )
                .toList();
            final String getId = receivedData['id'] as String;
            final String getName = receivedData['name'] as String;
            final UserData setData = UserData(
              imgList: imgListDecode,
              id: getId,
              name: getName,
              birthday: "",
              family: "",
            );
            deviceList.value = [...deviceList.value, setData];
          }
        },
      );
    }

    Future<void> initNearbyService() async {
      await nearbyService.init(
        serviceType: 'bobo',
        deviceName: userData.id,
        strategy: Strategy.P2P_CLUSTER,
        callback: (bool isRunning) async {
          if (isRunning) {
            try {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future<void>.delayed(const Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
              await Future<void>.delayed(const Duration(microseconds: 200));
              ss();
              setupReceivedDataSubscription();
            } catch (e) {
              return;
            }
          }
        },
      );
    }

    useEffect(
      () {
        initNearbyService();

        return null;
      },
      [],
    );

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      appBar: appberWithLogo(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
              child: SizedBox(
                height: safeAreaHeight * 0.23,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: safeAreaWidth * 0.04,
                      ),
                      for (int i = 0; i < deviceList.value.length; i++) ...{
                        OnStory(
                          key: ValueKey(" ${deviceList.value[i]} $i"),
                          isMyData: i == 0,
                          data: deviceList.value[i],
                          index: i,
                          onTap: () {
                            Navigator.push<Widget>(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) => StoryPage(
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
              ),
            ),
            line(context, top: safeAreaHeight * 0.01, bottom: 1),
            for (int i = 0; i < 1; i++) ...{onTalk(context)},
            SizedBox(
              height: safeAreaHeight * 0.11,
            ),
            for (int i = 0; i < transmissionHistory.value.length; i++) ...{
              Text(
                transmissionHistory.value[i],
                style: const TextStyle(color: Colors.red),
              )
            },
            bottomButton(
              context: context,
              isWhiteMainColor: true,
              text: "削除",
              onTap: () async {},
            ),
            SizedBox(
              height: safeAreaHeight * 0.11,
            ),
          ],
        ),
      ),
    );
  }
}
