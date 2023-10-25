import 'dart:convert';

import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'device_list.g.dart';

@Riverpod(keepAlive: false)
class DeviseListNotifier extends _$DeviseListNotifier {
  final nearbyService = NearbyService();

  @override
  List<String> build() {
    return [];
  }

  Future<void> initNearbyService(UserData userData) async {
    final nearbyService = NearbyService();
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
            callbackNearbyService(userData);
            // setupReceivedDataSubscription();
          } catch (e) {
            return;
          }
        }
      },
    );
  }

  Future<void> callbackNearbyService(UserData userData) async {
    final Map<String, dynamic> setUserData = <String, dynamic>{
      'type': 'image',
      'id': userData.id,
      'name': userData.name,
    };
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
            if (!state.contains(device.deviceId)) {
              try {
                nearbyService.sendMessage(
                  device.deviceId,
                  jsonEncode(setUserData),
                );
                state = [...state, device.deviceId];
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
          final notifier = ref.read(storyListNotifierProvider.notifier);
          notifier.addData(receivedData);
        }
      },
    );
  }

  Future<void> resetData() async {
    await nearbyService.stopAdvertisingPeer();
    await nearbyService.stopBrowsingForPeers();
    state = [];
  }
}
