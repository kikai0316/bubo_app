import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_list.g.dart';

@Riverpod(keepAlive: true)
class HistoryListNotifier extends _$HistoryListNotifier {
  @override
  Future<List<String>> build() async {
    final List<String> getData = await readHistoryData();
    return getData;
  }

  Future<void> reLoad() async {
    final List<String> getData = await readHistoryData();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return getData;
    });
  }

  Future<void> add(String id) async {
    await writeHistoryData([...state.value!, id]);
    final List<String> getData = await readHistoryData();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return getData;
    });
  }
}
