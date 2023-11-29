import 'package:bubu_app/model/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'story_list.g.dart';

@Riverpod(keepAlive: true)
class StoryListNotifier extends _$StoryListNotifier {
  @override
  List<UserData> build() {
    return [];
  }

  Future<void> addData(UserData data) async {
    state = [...state, data];
  }

  Future<void> dataUpDate(UserData newUserData) async {
    final int index =
        state.indexWhere((userData) => userData.id == newUserData.id);
    if (index != -1) {
      final setList = [...state];
      setList[index] = newUserData;
      state = setList;
    }
  }

  void isViwUpDate(UserData newUserData) {
    final int index =
        state.indexWhere((userData) => userData.id == newUserData.id);
    if (index != -1) {
      final setList = [...state];
      setList[index] = newUserData;
      state = setList;
    }
  }
}
