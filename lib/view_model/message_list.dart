import 'dart:async';
import 'dart:math';

import 'package:bubu_app/component/aes_key.dart';
import 'package:bubu_app/constant/emoji.dart';
import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/aes_utility.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'message_list.g.dart';

StreamSubscription<DatabaseEvent>? event;
// ignore: deprecated_member_use
final databaseReference = FirebaseDatabase(
  databaseURL:
      "https://bobo-app-9e643-default-rtdb.asia-southeast1.firebasedatabase.app",
).ref("messages");

@Riverpod(keepAlive: true)
class MessageListNotifier extends _$MessageListNotifier {
  @override
  Future<List<MessageList>> build() async {
    final getData = await readeMessageData();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      messageListen(user.uid);
    }
    return getData;
  }

  Future<void> mainImgUpDate(
    UserData newUserData,
    MessageList messageData,
  ) async {
    final int index = state.value!
        .indexWhere((userData) => userData.userData.id == newUserData.id);
    if (index != -1) {
      final setList = [...state.value!];
      final setData =
          MessageList(message: messageData.message, userData: newUserData);
      setList[index] = setData;
      final isLocalWrite = await writeMessageData(setList);
      if (isLocalWrite) {
        state = await AsyncValue.guard(() async {
          return setList;
        });
      }
    }
  }

  Future<void> dataUpDate(MessageList newMessagerData) async {
    final int index = state.value!.indexWhere(
      (messagerData) => messagerData.userData.id == newMessagerData.userData.id,
    );
    if (index != -1) {
      final setList = [...state.value!];
      setList[index] = newMessagerData;
      final isLocalWrite = await writeMessageData(setList);
      if (isLocalWrite) {
        state = await AsyncValue.guard(() async {
          return setList;
        });
      }
    }
  }

  Future<void> dataDelete(String id) async {
    final int index = state.value!.indexWhere(
      (messagerData) => messagerData.userData.id == id,
    );
    if (index != -1) {
      final setList = [...state.value!];
      setList.removeAt(index);
      final isLocalWrite = await writeMessageData(setList);
      if (isLocalWrite) {
        state = await AsyncValue.guard(() async {
          return setList;
        });
      }
    }
  }

  Future<bool> addMessage({
    required MessageData messageData,
    required UserData userData,
  }) async {
    final int index = state.value!
        .indexWhere((messagerData) => messagerData.userData.id == userData.id);
    if (index != -1) {
      final setList = [...state.value!];
      final existingMessages = setList[index].message;
      final bool isDuplicate = existingMessages.any(
        (existingMessage) =>
            existingMessage.dateTime.day == messageData.dateTime.day &&
            existingMessage.dateTime.month == messageData.dateTime.month &&
            existingMessage.dateTime.year == messageData.dateTime.year &&
            existingMessage.valueKey == messageData.valueKey,
      );
      if (!isDuplicate) {
        setList[index] = MessageList(
          userData: setList[index].userData,
          message: [
            ...setList[index].message,
            messageData,
          ],
        );
        final isLocalWrite = await writeMessageData(setList);
        if (isLocalWrite) {
          state = await AsyncValue.guard(() async {
            return setList;
          });
        } else {
          return false;
        }
      }
    } else {
      final setList = [
        MessageList(
          userData: userData,
          message: [
            messageData,
          ],
        ),
        ...state.value!,
      ];
      final isLocalWrite = await writeMessageData(setList);
      if (isLocalWrite) {
        state = await AsyncValue.guard(() async {
          return setList;
        });
      }
    }
    return true;
  }

  void messageListen(String myID) {
    event = databaseReference.child(myID).onValue.listen((event) async {
      if (event.snapshot.value != null) {
        //存在する場合
        final data = event.snapshot.value! as Map<dynamic, dynamic>;
        data.forEach((userId, userData) async {
          final id = userId as String;
          if (myID != id) {
            final List<MessageData> sortMessagesList = [];
            // ignore: avoid_dynamic_calls
            await userData.forEach((messageId, messageData) async {
              try {
                final setValue = messageData as Map<dynamic, dynamic>;
                final date = setValue['date'] as String;
                final index = setValue['index'] as String;
                final message = setValue['message'] as String;
                final messageDecode =
                    await aesDecryption(message, int.parse(index));
                if (messageDecode != null) {
                  sortMessagesList.add(
                    MessageData(
                      isMyMessage: false,
                      message: messageDecode,
                      dateTime: DateTime.parse(date),
                      isRead: false,
                      valueKey: messageId as String,
                    ),
                  );
                }
              } catch (e) {
                return;
              }
            });
            final setList = sortMessagesByDate(sortMessagesList);
            for (final element in setList) {
              final isSuccess = await addMessage(
                messageData: element,
                userData: UserData(
                  imgList: [],
                  id: id,
                  name: "データ取得中...",
                  birthday: "",
                  family: "",
                  instagram: "",
                  isGetData: false,
                  isView: false,
                  acquisitionAt: null,
                ),
              );
              if (isSuccess) {
                messageSnackbar(
                  messageText: emojiData.containsKey(element.message)
                      ? "リアクションがありました"
                      : element.message,
                  name: "だおすけええ",
                  id: id,
                );
                await databaseReference
                    .child(myID)
                    .child(id)
                    .child(element.valueKey)
                    .remove();
              }
            }
          }
        });
      } else {
        await databaseReference.child(myID).child(myID).set("");
      }
    });
  }

  Future<bool> sendMessage(
    String myUserID,
    UserData userData,
    String message,
  ) async {
    try {
      final int keyIndex = Random().nextInt(aesKeyList.length);
      final messageEncode = await aesEncryption(message, keyIndex);
      final getKey = generateRandomString();
      if (messageEncode == null) {
        return false;
      } else {
        final isSuccess = await databaseReference
            .child(userData.id)
            .child(myUserID)
            .child(getKey)
            .set({
              "message": messageEncode,
              "index": keyIndex.toString(),
              "date": DateTime.now().toString(),
            })
            .then((value) => true)
            .onError((error, stackTrace) => false);
        if (isSuccess) {
          addMessage(
            messageData: MessageData(
              isMyMessage: true,
              message: message,
              dateTime: DateTime.now(),
              valueKey: getKey,
              isRead: true,
            ),
            userData: userData,
          );
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> reLoad() async {
    final getData = await readeMessageData();
    state = await AsyncValue.guard(() async {
      return getData;
    });
  }

  Future<void> reSet() async {
    state = await AsyncValue.guard(() async {
      return [];
    });
  }
}

String generateRandomString() {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();

  return String.fromCharCodes(
    Iterable.generate(
      10,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ),
  );
}

List<MessageData> sortMessagesByDate(List<MessageData> messages) {
  final setData = [...messages];
  setData.sort((a, b) {
    final DateTime dateA = a.dateTime;
    final DateTime dateB = b.dateTime;
    return dateA.compareTo(dateB);
  });
  return setData;
}
