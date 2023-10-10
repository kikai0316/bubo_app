// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MessageData {
  UserData get userData => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageDataCopyWith<MessageData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDataCopyWith<$Res> {
  factory $MessageDataCopyWith(
          MessageData value, $Res Function(MessageData) then) =
      _$MessageDataCopyWithImpl<$Res, MessageData>;
  @useResult
  $Res call(
      {UserData userData, String message, DateTime dateTime, bool isRead});

  $UserDataCopyWith<$Res> get userData;
}

/// @nodoc
class _$MessageDataCopyWithImpl<$Res, $Val extends MessageData>
    implements $MessageDataCopyWith<$Res> {
  _$MessageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userData = null,
    Object? message = null,
    Object? dateTime = null,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      userData: null == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as UserData,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res> get userData {
    return $UserDataCopyWith<$Res>(_value.userData, (value) {
      return _then(_value.copyWith(userData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MessageDataCopyWith<$Res>
    implements $MessageDataCopyWith<$Res> {
  factory _$$_MessageDataCopyWith(
          _$_MessageData value, $Res Function(_$_MessageData) then) =
      __$$_MessageDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserData userData, String message, DateTime dateTime, bool isRead});

  @override
  $UserDataCopyWith<$Res> get userData;
}

/// @nodoc
class __$$_MessageDataCopyWithImpl<$Res>
    extends _$MessageDataCopyWithImpl<$Res, _$_MessageData>
    implements _$$_MessageDataCopyWith<$Res> {
  __$$_MessageDataCopyWithImpl(
      _$_MessageData _value, $Res Function(_$_MessageData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userData = null,
    Object? message = null,
    Object? dateTime = null,
    Object? isRead = null,
  }) {
    return _then(_$_MessageData(
      userData: null == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as UserData,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_MessageData implements _MessageData {
  const _$_MessageData(
      {required this.userData,
      required this.message,
      required this.dateTime,
      required this.isRead});

  @override
  final UserData userData;
  @override
  final String message;
  @override
  final DateTime dateTime;
  @override
  final bool isRead;

  @override
  String toString() {
    return 'MessageData(userData: $userData, message: $message, dateTime: $dateTime, isRead: $isRead)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessageData &&
            (identical(other.userData, userData) ||
                other.userData == userData) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userData, message, dateTime, isRead);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageDataCopyWith<_$_MessageData> get copyWith =>
      __$$_MessageDataCopyWithImpl<_$_MessageData>(this, _$identity);
}

abstract class _MessageData implements MessageData {
  const factory _MessageData(
      {required final UserData userData,
      required final String message,
      required final DateTime dateTime,
      required final bool isRead}) = _$_MessageData;

  @override
  UserData get userData;
  @override
  String get message;
  @override
  DateTime get dateTime;
  @override
  bool get isRead;
  @override
  @JsonKey(ignore: true)
  _$$_MessageDataCopyWith<_$_MessageData> get copyWith =>
      throw _privateConstructorUsedError;
}
