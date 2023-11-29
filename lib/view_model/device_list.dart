import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bubu_app/component/aes_key.dart';
import 'package:bubu_app/constant/emoji.dart';
import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/aes_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'device_list.g.dart';

NearbyService? nearbyService;
StreamSubscription<dynamic>? stateChangedSubscription;
StreamSubscription<dynamic>? dataReceivedSubscription;

@Riverpod(keepAlive: true)
class DeviseListNotifier extends _$DeviseListNotifier {
  @override
  List<Device>? build() {
    return null;
  }

  Future<void> initNearbyService(UserData userData) async {
    nearbyService = NearbyService();
    state = [];
    await nearbyService?.init(
      serviceType: 'bobo',
      deviceName: userData.id,
      strategy: Strategy.P2P_CLUSTER,
      callback: (bool isRunning) async {
        if (isRunning) {
          try {
            await nearbyService?.stopAdvertisingPeer();
            await nearbyService?.stopBrowsingForPeers();
            await stateChangedSubscription?.cancel();
            await dataReceivedSubscription?.cancel();
            await Future<void>.delayed(const Duration(microseconds: 200));
            await nearbyService?.startAdvertisingPeer();
            await nearbyService?.startBrowsingForPeers();
            await Future<void>.delayed(const Duration(microseconds: 200));
            callbackNearbyService();
            setupReceivedDataSubscription();
          } catch (e) {
            await nearbyService?.stopAdvertisingPeer();
            await nearbyService?.stopBrowsingForPeers();
            state = null;
            return;
          }
        }
      },
    );
  }

  Future<void> callbackNearbyService() async {
    stateChangedSubscription = nearbyService?.stateChangedSubscription(
      callback: (devicesList) async {
        final setDevicesList = [...devicesList];
        if (devicesList.length > 20) {
          devicesList.removeRange(20, devicesList.length);
        }
        // for (final device in setDevicesList) {
        //   final notifier = ref.read(storyListNotifierProvider.notifier);
        //   // notifier.addData(device.deviceId);
        // }
        state = setDevicesList;
      },
    );
  }

  Future<void> setupReceivedDataSubscription() async {
    dataReceivedSubscription = nearbyService?.dataReceivedSubscription(
      callback: (dynamic data) async {
        final receivedData =
            // ignore: avoid_dynamic_calls
            jsonDecode(data['message'] as String) as Map<String, dynamic>;
        if (receivedData["type"] == 'message') {
          final name = receivedData['name'] as String;
          final id = receivedData['id'] as String;
          final message = receivedData['message'] as String;
          final keyIndex = receivedData['index'] as String;
          final messageDecode =
              await aesDecryption(message, int.parse(keyIndex));
          if (messageDecode != null) {
            messageSnackbar(
              messageText: emojiData.containsKey(messageDecode)
                  ? "リアクションがありました"
                  : messageDecode,
              name: name,
              id: id,
            );
            final notifier = ref.read(messageListNotifierProvider.notifier);
            notifier.addMessage(
              messageData: MessageData(
                isMyMessage: false,
                message: messageDecode,
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
        }
      },
    );
  }

  Future<void> resetData() async {
    await stateChangedSubscription?.cancel();
    await dataReceivedSubscription?.cancel();
    await nearbyService?.stopAdvertisingPeer();
    await nearbyService?.stopBrowsingForPeers();
    state = null;
  }

  Future<void> sendMessageCancel() async {
    final setData = [...state!];
    state = [];
    await Future<void>.delayed(const Duration(seconds: 1));
    state = setData;
  }

  Future<bool> sendMessage({
    required String message,
    required UserData userData,
    required UserData myData,
  }) async {
    final int keyIndex = Random().nextInt(aesKeyList.length);
    final messageEncode = await aesEncryption(message, keyIndex);
    bool isLoop = true;
    if (messageEncode == null) {
      return false;
    } else {
      final notifier = ref.read(messageListNotifierProvider.notifier);
      final Map<String, dynamic> setUserData = <String, dynamic>{
        'type': 'message',
        'id': myData.id,
        'index': keyIndex.toString(),
        'name': myData.name,
        'message': messageEncode,
      };
      while (isLoop) {
        final Device foundDevice = (state ?? []).firstWhere(
          (device) => device.deviceId == userData.id,
          orElse: () => Device("", "", 0),
        );
        if (foundDevice.deviceId != "") {
          if (foundDevice.state == SessionState.notConnected) {
            try {
              nearbyService?.invitePeer(
                deviceID: foundDevice.deviceId,
                deviceName: foundDevice.deviceName,
              );
              // ignore: empty_catches
            } catch (e) {}
          }
          if (foundDevice.state == SessionState.connected) {
            isLoop = false;
            try {
              nearbyService?.sendMessage(
                userData.id,
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
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      return false;
    }
  }
}
