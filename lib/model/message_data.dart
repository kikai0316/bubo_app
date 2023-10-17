import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_data.freezed.dart';

@freezed
class MessageData with _$MessageData {
  const factory MessageData({
    required String userId,
    required String message,
    required DateTime dateTime,
    required bool isRead,
  }) = _MessageData;
}
