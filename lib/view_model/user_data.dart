import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data.g.dart';

@Riverpod(keepAlive: true)
class UserDataNotifier extends _$UserDataNotifier {
  @override
  Future<UserData?> build() async {
    final UserData? userData = await readUserData();
    if (userData != null) {
      final userDataCheck = await instagramStateCheck(userData);
      return userDataCheck;
    } else {
      return null;
    }
  }

  Future<void> reLoad() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getData = await readUserData();
      if (getData != null) {
        final userDataCheck = await instagramStateCheck(getData);
        return userDataCheck;
      } else {
        return null;
      }
    });
  }

  Future<void> isViewupData() async {
    final setData = UserData(
      imgList: state.value!.imgList,
      id: state.value!.id,
      name: state.value!.name,
      birthday: state.value!.birthday,
      family: state.value!.family,
      instagram: state.value!.instagram,
      isGetData: true,
      isView: true,
      acquisitionAt: null,
    );
    final iswWite = await writeUserData(setData);
    if (iswWite) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        return setData;
      });
    }
  }
}

Future<UserData> instagramStateCheck(UserData data) async {
  final instagramCheck = await getInstagramAccount(data.instagram);
  if (instagramCheck == null) {
    final setData = UserData(
      imgList: data.imgList,
      id: data.id,
      name: data.name,
      birthday: data.birthday,
      instagram: "",
      family: data.family,
      isGetData: data.isGetData,
      isView: data.isView,
      acquisitionAt: data.acquisitionAt,
    );
    await writeUserData(setData);
    return setData;
  } else {
    return data;
  }
}
