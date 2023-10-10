import 'package:bubu_app/model/user_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_data.freezed.dart';

@freezed
class MessageData with _$MessageData {
  const factory MessageData({
    required UserData userData,
    required String message,
    required DateTime dateTime,
    required bool isRead,
  }) = _MessageData;
}
