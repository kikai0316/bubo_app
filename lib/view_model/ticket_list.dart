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

  Future<void> deleteAD() async {
    bool isFree = false;
    bool isAd = false;
    final setFree = [...state.value!.free];
    final setAd = [...state.value!.ad];
    setFree.removeWhere((ticket) {
      final setBool = ticket.acquisitionAt
          .add(const Duration(hours: 12))
          .isBefore(DateTime.now());
      isFree = setBool;
      return setBool;
    });
    setAd.removeWhere((ticket) {
      final setBool = ticket.acquisitionAt
          .add(const Duration(hours: 12))
          .isBefore(DateTime.now());
      isAd = setBool;
      return setBool;
    });
    if (isFree || isAd) {
      final setList = TicketList(
        free: isFree ? setFree : state.value!.free,
        ad: isAd ? setAd : state.value!.ad,
      );
      final isWrite = await writeTicketData(setList);
      if (isWrite) {
        state = await AsyncValue.guard(() async {
          return setList;
        });
      }
    }
  }
}
