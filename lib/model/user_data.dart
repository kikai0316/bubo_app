import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required List<Uint8List> imgList,
    required String id,
    required String name,
    required String birthday,
    required String family,
  }) = _UserData;
}
