import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'story_list.g.dart';

@Riverpod(keepAlive: true)
class StoryListNotifier extends _$StoryListNotifier {
  @override
  Future<List<UserData>> build() async {
    final List<UserData> getData = await readStoryData();
    return hasExceeded24Hours(getData);
  }

  Future<void> addData(Map<String, dynamic> data) async {
    try {
      final userID = data['id'] as String;
      final userNAME = data['name'] as String;
      if (!state.value!.any(
        (userData) => userData.id == userID,
      )) {
        final setUserData = UserData(
          imgList: [],
          id: userID,
          name: userNAME,
          birthday: "",
          family: "",
          isGetData: false,
          isView: false,
          acquisitionAt: DateTime.now(),
        );
        final setList = [...state.value!, setUserData];
        final isLocalWrite = await writeStoryData(setList);
        if (isLocalWrite) {
          state = const AsyncValue.loading();
          state = await AsyncValue.guard(() async {
            return setList;
          });
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> dataUpDate(UserData newUserData) async {
    final int index =
        state.value!.indexWhere((userData) => userData.id == newUserData.id);
    if (index != -1) {
      final setList = [...state.value!];
      setList[index] = newUserData;
      final isLocalWrite = await writeStoryData(setList);
      if (isLocalWrite) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() async {
          return setList;
        });
      }
    }
  }

  Future<void> isViwUpDate(UserData newUserData) async {
    final int index =
        state.value!.indexWhere((userData) => userData.id == newUserData.id);
    if (index != -1) {
      final setList = [...state.value!];
      setList[index] = newUserData;
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        return setList;
      });
    }
  }
}

Future<List<UserData>> hasExceeded24Hours(List<UserData> data) async {
  final DateTime now = DateTime.now();
  final DateTime twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
  bool isEdit = false;
  final List<UserData> newData = [...data];
  for (int i = 0; i < newData.length; i++) {
    if (newData[i].acquisitionAt == null) {
      isEdit = true;
      newData.removeAt(i);
    } else {
      if (newData[i].acquisitionAt!.isBefore(twentyFourHoursAgo)) {
        isEdit = true;
        newData.removeAt(i);
      }
    }
  }
  if (isEdit) {
    await writeStoryData(newData);
  }
  return newData;
}
