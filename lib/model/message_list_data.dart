import 'package:bubu_app/model/message_data.dart';
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
