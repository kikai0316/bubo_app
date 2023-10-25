// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_list_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MessageList {
  UserData get userData => throw _privateConstructorUsedError;
  List<MessageData> get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageListCopyWith<MessageList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageListCopyWith<$Res> {
  factory $MessageListCopyWith(
          MessageList value, $Res Function(MessageList) then) =
      _$MessageListCopyWithImpl<$Res, MessageList>;
  @useResult
  $Res call({UserData userData, List<MessageData> message});

  $UserDataCopyWith<$Res> get userData;
}

/// @nodoc
class _$MessageListCopyWithImpl<$Res, $Val extends MessageList>
    implements $MessageListCopyWith<$Res> {
  _$MessageListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userData = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      userData: null == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as UserData,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as List<MessageData>,
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
abstract class _$$MessageListImplCopyWith<$Res>
    implements $MessageListCopyWith<$Res> {
  factory _$$MessageListImplCopyWith(
          _$MessageListImpl value, $Res Function(_$MessageListImpl) then) =
      __$$MessageListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserData userData, List<MessageData> message});

  @override
  $UserDataCopyWith<$Res> get userData;
}

/// @nodoc
class __$$MessageListImplCopyWithImpl<$Res>
    extends _$MessageListCopyWithImpl<$Res, _$MessageListImpl>
    implements _$$MessageListImplCopyWith<$Res> {
  __$$MessageListImplCopyWithImpl(
      _$MessageListImpl _value, $Res Function(_$MessageListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userData = null,
    Object? message = null,
  }) {
    return _then(_$MessageListImpl(
      userData: null == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as UserData,
      message: null == message
          ? _value._message
          : message // ignore: cast_nullable_to_non_nullable
              as List<MessageData>,
    ));
  }
}

/// @nodoc

class _$MessageListImpl implements _MessageList {
  const _$MessageListImpl(
      {required this.userData, required final List<MessageData> message})
      : _message = message;

  @override
  final UserData userData;
  final List<MessageData> _message;
  @override
  List<MessageData> get message {
    if (_message is EqualUnmodifiableListView) return _message;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_message);
  }

  @override
  String toString() {
    return 'MessageList(userData: $userData, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageListImpl &&
            (identical(other.userData, userData) ||
                other.userData == userData) &&
            const DeepCollectionEquality().equals(other._message, _message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, userData, const DeepCollectionEquality().hash(_message));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageListImplCopyWith<_$MessageListImpl> get copyWith =>
      __$$MessageListImplCopyWithImpl<_$MessageListImpl>(this, _$identity);
}

abstract class _MessageList implements MessageList {
  const factory _MessageList(
      {required final UserData userData,
      required final List<MessageData> message}) = _$MessageListImpl;

  @override
  UserData get userData;
  @override
  List<MessageData> get message;
  @override
  @JsonKey(ignore: true)
  _$$MessageListImplCopyWith<_$MessageListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
