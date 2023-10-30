import 'dart:convert';

import 'package:bubu_app/model/message_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'device_list.g.dart';

final nearbyService = NearbyService();

@Riverpod(keepAlive: true)
class DeviseListNotifier extends _$DeviseListNotifier {
  @override
  List<String> build() {
    return [];
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
    bool isRunning = false;
    nearbyService.stateChangedSubscription(
      callback: (devicesList) async {
        if (!isRunning) {
          isRunning = true;
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
            if (device.state == SessionState.connecting) {
              final notifier = ref.read(storyListNotifierProvider.notifier);
              notifier.addData(device.deviceId);
            }
          }
          isRunning = false;
        }
        state = devicesList
            .map((element) => element.deviceId.split('@')[0])
            .toList();
        // notifier.fromDeviceList(devicesList);
        // print(state);
      },
    );
  }

  void setupReceivedDataSubscription() {
    nearbyService.dataReceivedSubscription(
      callback: (dynamic data) {
        final receivedData =
            // ignore: avoid_dynamic_calls
            jsonDecode(data['message'] as String) as Map<String, dynamic>;
        // if (receivedData["type"] == 'image') {
        //   final notifier = ref.read(storyListNotifierProvider.notifier);
        //   notifier.addData(receivedData);
        // }
        if (receivedData["type"] == 'message') {
          final notifier = ref.read(messageListNotifierProvider.notifier);
          notifier.addMessage(
            messageData: MessageData(
              isMyMessage: false,
              message: receivedData['message'] as String,
              dateTime: DateTime.now(),
              isRead: false,
            ),
            userData: UserData(
              imgList: [],
              id: receivedData['id'] as String,
              name: receivedData['name'] as String,
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
    state = [];
  }

  void sendMessage(
    BuildContext context, {
    required String message,
    required UserData userData,
    required UserData myData,
  }) {
    final safeAreaHeight = safeHeight(context);
    final notifier = ref.read(messageListNotifierProvider.notifier);
    final Map<String, dynamic> setUserData = <String, dynamic>{
      'type': 'message',
      'id': myData.id,
      'name': myData.name,
      'message': message,
    };
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
    } catch (e) {
      errorSnackbar(
        context,
        text: "メッセージ送信中にエラーが発生しました",
        padding: safeAreaHeight * 0.08,
      );
    }
  }
}
