// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TicketList {
  List<TicketData> get free => throw _privateConstructorUsedError;
  List<TicketData> get ad => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketListCopyWith<TicketList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketListCopyWith<$Res> {
  factory $TicketListCopyWith(
          TicketList value, $Res Function(TicketList) then) =
      _$TicketListCopyWithImpl<$Res, TicketList>;
  @useResult
  $Res call({List<TicketData> free, List<TicketData> ad});
}

/// @nodoc
class _$TicketListCopyWithImpl<$Res, $Val extends TicketList>
    implements $TicketListCopyWith<$Res> {
  _$TicketListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? free = null,
    Object? ad = null,
  }) {
    return _then(_value.copyWith(
      free: null == free
          ? _value.free
          : free // ignore: cast_nullable_to_non_nullable
              as List<TicketData>,
      ad: null == ad
          ? _value.ad
          : ad // ignore: cast_nullable_to_non_nullable
              as List<TicketData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketListImplCopyWith<$Res>
    implements $TicketListCopyWith<$Res> {
  factory _$$TicketListImplCopyWith(
          _$TicketListImpl value, $Res Function(_$TicketListImpl) then) =
      __$$TicketListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TicketData> free, List<TicketData> ad});
}

/// @nodoc
class __$$TicketListImplCopyWithImpl<$Res>
    extends _$TicketListCopyWithImpl<$Res, _$TicketListImpl>
    implements _$$TicketListImplCopyWith<$Res> {
  __$$TicketListImplCopyWithImpl(
      _$TicketListImpl _value, $Res Function(_$TicketListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? free = null,
    Object? ad = null,
  }) {
    return _then(_$TicketListImpl(
      free: null == free
          ? _value._free
          : free // ignore: cast_nullable_to_non_nullable
              as List<TicketData>,
      ad: null == ad
          ? _value._ad
          : ad // ignore: cast_nullable_to_non_nullable
              as List<TicketData>,
    ));
  }
}

/// @nodoc

class _$TicketListImpl implements _TicketList {
  const _$TicketListImpl(
      {required final List<TicketData> free,
      required final List<TicketData> ad})
      : _free = free,
        _ad = ad;

  final List<TicketData> _free;
  @override
  List<TicketData> get free {
    if (_free is EqualUnmodifiableListView) return _free;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_free);
  }

  final List<TicketData> _ad;
  @override
  List<TicketData> get ad {
    if (_ad is EqualUnmodifiableListView) return _ad;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ad);
  }

  @override
  String toString() {
    return 'TicketList(free: $free, ad: $ad)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketListImpl &&
            const DeepCollectionEquality().equals(other._free, _free) &&
            const DeepCollectionEquality().equals(other._ad, _ad));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_free),
      const DeepCollectionEquality().hash(_ad));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketListImplCopyWith<_$TicketListImpl> get copyWith =>
      __$$TicketListImplCopyWithImpl<_$TicketListImpl>(this, _$identity);
}

abstract class _TicketList implements TicketList {
  const factory _TicketList(
      {required final List<TicketData> free,
      required final List<TicketData> ad}) = _$TicketListImpl;

  @override
  List<TicketData> get free;
  @override
  List<TicketData> get ad;
  @override
  @JsonKey(ignore: true)
  _$$TicketListImplCopyWith<_$TicketListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
