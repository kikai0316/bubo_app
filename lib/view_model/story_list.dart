import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'story_list.g.dart';

@Riverpod(keepAlive: true)
class StoryListNotifier extends _$StoryListNotifier {
  @override
  Future<List<UserData>> build() async {
    final List<UserData> getData = await readStoryData();
    final setData = await initHasExceeded24Hours(getData);
    return setData;
  }

  Future<void> addData(String data) async {
    try {
      final List<String> getString = data.split('@');
      if (getString.length == 2) {
        if (!state.value!.any(
          (userData) => userData.id == getString[0],
        )) {
          final setUserData = UserData(
            imgList: [],
            id: getString[0],
            name: getString[1],
            birthday: "",
            family: "",
            isGetData: false,
            isView: false,
            acquisitionAt: DateTime.now(),
          );
          final setList = hasExceeded24Hours([...state.value!, setUserData]);
          final isLocalWrite = await writeStoryData(setList);
          if (isLocalWrite) {
            state = const AsyncValue.loading();
            state = await AsyncValue.guard(() async {
              return setList;
            });
          }
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
      final isLocalWrite = await writeStoryData(hasExceeded24Hours(setList));
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

  Future<void> reLoad() async {
    final List<UserData> getData = await readStoryData();
    final setData = await initHasExceeded24Hours(getData);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return setData;
    });
  }
}

Future<List<UserData>> initHasExceeded24Hours(List<UserData> data) async {
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

List<UserData> hasExceeded24Hours(List<UserData> data) {
  final DateTime now = DateTime.now();
  final DateTime twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
  final List<UserData> newData = [...data];
  for (int i = 0; i < newData.length; i++) {
    if (newData[i].acquisitionAt == null) {
      newData.removeAt(i);
    } else {
      if (newData[i].acquisitionAt!.isBefore(twentyFourHoursAgo)) {
        newData.removeAt(i);
      }
    }
  }
  return newData;
}
