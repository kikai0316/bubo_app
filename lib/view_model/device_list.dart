import 'dart:async';
import 'dart:convert';
import 'package:bubu_app/constant/emoji.dart';
import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'device_list.g.dart';

final nearbyService = NearbyService();

@Riverpod(keepAlive: true)
class DeviseListNotifier extends _$DeviseListNotifier {
  @override
  List<Device>? build() {
    final notifierUser = ref.watch(userDataNotifierProvider);
    final notifierUserWhen = notifierUser.when(
      data: (value) {
        if (value == null) {
          return null;
        } else {
          initNearbyService(value);
          return <Device>[];
        }
      },
      error: (e, s) => null,
      loading: () => null,
    );
    return notifierUserWhen;
  }

  Future<void> initNearbyService(UserData userData) async {
    await nearbyService.init(
      serviceType: 'bobo',
      deviceName: "${userData.id}@${userData.name}",
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
            setupReceivedDataSubscription();
          } catch (e) {
            await nearbyService.stopAdvertisingPeer();
            await nearbyService.stopBrowsingForPeers();
            return;
          }
        }
      },
    );
  }

  Future<void> callbackNearbyService(UserData userData) async {
    nearbyService.stateChangedSubscription(
      callback: (devicesList) async {
        final setDevicesList = [...devicesList];
        if (devicesList.length > 20) {
          devicesList.removeRange(20, devicesList.length);
        }
        for (final device in setDevicesList) {
          final notifier = ref.read(storyListNotifierProvider.notifier);
          notifier.addData(device.deviceId);
        }
        state = setDevicesList;
      },
    );
  }

  Future<void> setupReceivedDataSubscription() async {
    nearbyService.dataReceivedSubscription(
      callback: (dynamic data) async {
        final receivedData =
            // ignore: avoid_dynamic_calls
            jsonDecode(data['message'] as String) as Map<String, dynamic>;
        if (receivedData["type"] == 'message') {
          final name = receivedData['name'] as String;
          final id = receivedData['id'] as String;
          final message = receivedData['message'] as String;
          messageSnackbar(
            messageText:
                emojiData.containsKey(message) ? "リアクションがありました" : message,
            name: name,
            id: id,
          );
          final notifier = ref.read(messageListNotifierProvider.notifier);
          notifier.addMessage(
            messageData: MessageData(
              isMyMessage: false,
              message: message,
              dateTime: DateTime.now(),
              isRead: false,
            ),
            userData: UserData(
              imgList: [],
              id: id,
              name: name,
              birthday: "",
              family: "",
              instagram: "",
              isGetData: false,
              isView: false,
              acquisitionAt: null,
            ),
          );
        }
      },
    );
  }

  Future<void> resetData() async {
    await nearbyService.stopAdvertisingPeer();
    await nearbyService.stopBrowsingForPeers();
    state = null;
  }

  Future<bool> sendMessage({
    required String message,
    required UserData userData,
    required UserData myData,
  }) async {
    final notifier = ref.read(messageListNotifierProvider.notifier);
    final Map<String, dynamic> setUserData = <String, dynamic>{
      'type': 'message',
      'id': myData.id,
      'name': myData.name,
      'message': message,
    };
    bool isLoop = true;
    while (isLoop) {
      final Device foundDevice = (state ?? []).firstWhere(
        (device) => device.deviceId.split('@')[0] == userData.id,
        orElse: () => Device("", "", 0),
      );
      if (foundDevice.deviceId != "") {
        if (foundDevice.state == SessionState.notConnected) {
          try {
            nearbyService.invitePeer(
              deviceID: foundDevice.deviceId,
              deviceName: foundDevice.deviceName,
            );
            // ignore: empty_catches
          } catch (e) {}
        }
        if (foundDevice.state == SessionState.connecting) {}
        if (foundDevice.state == SessionState.connected) {
          isLoop = false;
          try {
            nearbyService.sendMessage(
              "${userData.id}@${userData.name}",
              jsonEncode(setUserData),
            );
            notifier.addMessage(
              messageData: MessageData(
                isMyMessage: true,
                message: message,
                dateTime: DateTime.now(),
                isRead: true,
              ),
              userData: userData,
            );
            return true;
          } catch (e) {
            isLoop = false;
            return false;
          }
        }
      } else {
        isLoop = false;
        return false;
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    return false;
  }
}
