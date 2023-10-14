import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data.g.dart';

@Riverpod(keepAlive: false)
class UserDataNotifier extends _$UserDataNotifier {
  @override
  Future<UserData?> build() async {
    final UserData? userData = await readUserData();
    return userData;
  }

  Future<void> reLoad() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getData = await readUserData();
      return getData;
    });
  }
}
