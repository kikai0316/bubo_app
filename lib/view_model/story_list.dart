import 'package:bubu_app/model/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'story_list.g.dart';

@Riverpod(keepAlive: true)
class StoryListNotifier extends _$StoryListNotifier {
  @override
  Future<List<UserData>> build() async {
    return [];
  }

  Future<void> addData(UserData data) async {
    state = await AsyncValue.guard(() async {
      return [...state.value!, data];
    });
  }

  Future<void> dataUpDate(UserData newUserData) async {
    final int index =
        state.value!.indexWhere((userData) => userData.id == newUserData.id);
    if (index != -1) {
      final setList = [...state.value!];
      setList[index] = newUserData;
      state = await AsyncValue.guard(() async {
        return [...setList];
      });
    }
  }

  Future<void> isViwUpDate(UserData newUserData) async {
    final int index =
        state.value!.indexWhere((userData) => userData.id == newUserData.id);
    if (index != -1) {
      final setList = [...state.value!];
      setList[index] = newUserData;
      state = await AsyncValue.guard(() async {
        return [...setList];
      });
    }
  }
}
