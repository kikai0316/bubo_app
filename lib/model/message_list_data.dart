import 'package:bubu_app/model/user_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_list_data.freezed.dart';

@freezed
class MessageList with _$MessageList {
  const factory MessageList({
    required UserData userData,
    required List<MessageData> message,
  }) = _MessageList;
}

class MessageData {
  bool isMyMessage;
  String message;
  String valueKey;
  DateTime dateTime;
  bool isRead;
  MessageData({
    required this.isMyMessage,
    required this.message,
    required this.dateTime,
    required this.isRead,
    required this.valueKey,
  });
}
