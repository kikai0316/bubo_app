import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_list.freezed.dart';

@freezed
class TicketList with _$TicketList {
  const factory TicketList({
    required List<TicketData> free,
    required List<TicketData> ad,
  }) = _TicketList;
}

class TicketData {
  String id;
  DateTime acquisitionAt;
  TicketData({
    required this.id,
    required this.acquisitionAt,
  });
}
