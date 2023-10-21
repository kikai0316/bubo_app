import 'package:bubu_app/model/message_list_data.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'message_list.g.dart';

@Riverpod(keepAlive: true)
class MessageListNotifier extends _$MessageListNotifier {
  @override
  Future<List<MessageList>> build() async {
    final getData = await readeMessageData();
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
        state = const AsyncValue.loading();
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
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() async {
          return setList;
        });
      }
    }
  }
}