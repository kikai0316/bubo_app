import 'dart:convert';
import 'dart:math';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/widget/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final deviceList = useState<List<UserData>>([]);
    final transmissionHistory = useState<List<String>>([]);
    final nearbyService = NearbyService();
    final myData = useState<UserData>(
      const UserData(imgList: [], id: "sssss", name: "だおすけ"),
    );

    Future<void> getData() async {
      final ByteData byteData = await rootBundle.load('assets/img/test.png');
      final Uint8List imageData = byteData.buffer.asUint8List();
      myData.value = UserData(
        imgList: [imageData],
        id: myData.value.id,
        name: myData.value.name,
      );
    }

    Future<void> sendImageToPeer(String deviceId) async {
      final ByteData byteData = await rootBundle.load('assets/img/test.png');
      final Uint8List imageData = byteData.buffer.asUint8List();
      final Map<String, dynamic> setImgData = <String, dynamic>{
        'type': 'image',
        'id': myData.value.id,
        'name': myData.value.name,
        'img': base64Encode(imageData)
      };
      nearbyService.sendMessage(deviceId, jsonEncode(setImgData));
    }

    Future<void> initNearbyService() async {
      await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: "${Random().nextInt(5)}@dsgedsfws",
        strategy: Strategy.P2P_CLUSTER,
        callback: (bool isRunning) async {
          if (isRunning) {
            await nearbyService.startAdvertisingPeer();
            await nearbyService.startBrowsingForPeers();
          }
        },
      );
      nearbyService.stateChangedSubscription(
        callback: (devicesList) async {
          // deviceList.value = devicesList
          //     .map(
          //       (device) => UserData(
          //         imgList: [],
          //         id: device.deviceName.split('@')[1],
          //         name: device.deviceName.split('@')[0],
          //       ),
          //     )
          //     .toList();
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
          final Map<String, dynamic> receivedData =
              jsonDecode(data as String) as Map<String, dynamic>;
          if (receivedData['type'] == 'image') {
            final Uint8List getImg =
                base64Decode(receivedData['img'] as String);
            final String getId = receivedData['id'] as String;
            final String getName = receivedData['name'] as String;
            final UserData setData =
                UserData(imgList: [getImg], id: getId, name: getName);
            deviceList.value = [...deviceList.value, setData];
          }
        },
      );
    }

    useEffect(
      () {
        initNearbyService();
        setupReceivedDataSubscription();
        getData();
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
                      SizedBox(width: safeAreaWidth * 0.03),
                      GestureDetector(
                        onTap: () {
                          Navigator.push<Widget>(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (_, __, ___) => ScreenPage(
                                heroTag: myData.value.id,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: myData.value.id,
                          child: onProfile(
                            context,
                            isMyData: true,
                            data: myData.value,
                          ),
                        ),
                      ),
                      for (int i = 0; i < deviceList.value.length; i++) ...{
                        onProfile(
                          context,
                          isMyData: false,
                          data: deviceList.value[i],
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
            )
          ],
        ),
      ),
    );
  }
}

class ScreenPage extends HookConsumerWidget {
  const ScreenPage({super.key, required this.heroTag});
  final String heroTag;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: heroTag,
      child: Scaffold(
        backgroundColor: blackColor,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/474x/58/0b/2b/580b2ba5fe0f8dd9e07d75984653b307.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
