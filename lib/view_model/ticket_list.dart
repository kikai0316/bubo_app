import 'package:bubu_app/model/ticket_list.dart';
import 'package:bubu_app/utility/path_provider_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ticket_list.g.dart';

@Riverpod(keepAlive: true)
class TicketListNotifier extends _$TicketListNotifier {
  @override
  Future<TicketList> build() async {
    final TicketList userData = await readTicketData();
    return userData;
  }

  Future<void> addData(TicketList newValue) async {
    final isWrite = await writeTicketData(newValue);
    if (isWrite) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        return newValue;
      });
    }
  }
}
