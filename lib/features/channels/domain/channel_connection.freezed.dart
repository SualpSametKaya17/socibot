// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelConnection {

 ChannelType get type; ChannelConnectionStatus get status; String? get accountName; DateTime? get lastSyncAt;
/// Create a copy of ChannelConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelConnectionCopyWith<ChannelConnection> get copyWith => _$ChannelConnectionCopyWithImpl<ChannelConnection>(this as ChannelConnection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelConnection&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.lastSyncAt, lastSyncAt) || other.lastSyncAt == lastSyncAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,status,accountName,lastSyncAt);

@override
String toString() {
  return 'ChannelConnection(type: $type, status: $status, accountName: $accountName, lastSyncAt: $lastSyncAt)';
}


}

/// @nodoc
abstract mixin class $ChannelConnectionCopyWith<$Res>  {
  factory $ChannelConnectionCopyWith(ChannelConnection value, $Res Function(ChannelConnection) _then) = _$ChannelConnectionCopyWithImpl;
@useResult
$Res call({
 ChannelType type, ChannelConnectionStatus status, String? accountName, DateTime? lastSyncAt
});




}
/// @nodoc
class _$ChannelConnectionCopyWithImpl<$Res>
    implements $ChannelConnectionCopyWith<$Res> {
  _$ChannelConnectionCopyWithImpl(this._self, this._then);

  final ChannelConnection _self;
  final $Res Function(ChannelConnection) _then;

/// Create a copy of ChannelConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? status = null,Object? accountName = freezed,Object? lastSyncAt = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChannelType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChannelConnectionStatus,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,lastSyncAt: freezed == lastSyncAt ? _self.lastSyncAt : lastSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelConnection].
extension ChannelConnectionPatterns on ChannelConnection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelConnection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelConnection value)  $default,){
final _that = this;
switch (_that) {
case _ChannelConnection():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelConnection value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelConnection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChannelType type,  ChannelConnectionStatus status,  String? accountName,  DateTime? lastSyncAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelConnection() when $default != null:
return $default(_that.type,_that.status,_that.accountName,_that.lastSyncAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChannelType type,  ChannelConnectionStatus status,  String? accountName,  DateTime? lastSyncAt)  $default,) {final _that = this;
switch (_that) {
case _ChannelConnection():
return $default(_that.type,_that.status,_that.accountName,_that.lastSyncAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChannelType type,  ChannelConnectionStatus status,  String? accountName,  DateTime? lastSyncAt)?  $default,) {final _that = this;
switch (_that) {
case _ChannelConnection() when $default != null:
return $default(_that.type,_that.status,_that.accountName,_that.lastSyncAt);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelConnection implements ChannelConnection {
  const _ChannelConnection({required this.type, required this.status, this.accountName, this.lastSyncAt});
  

@override final  ChannelType type;
@override final  ChannelConnectionStatus status;
@override final  String? accountName;
@override final  DateTime? lastSyncAt;

/// Create a copy of ChannelConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelConnectionCopyWith<_ChannelConnection> get copyWith => __$ChannelConnectionCopyWithImpl<_ChannelConnection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelConnection&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.lastSyncAt, lastSyncAt) || other.lastSyncAt == lastSyncAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,status,accountName,lastSyncAt);

@override
String toString() {
  return 'ChannelConnection(type: $type, status: $status, accountName: $accountName, lastSyncAt: $lastSyncAt)';
}


}

/// @nodoc
abstract mixin class _$ChannelConnectionCopyWith<$Res> implements $ChannelConnectionCopyWith<$Res> {
  factory _$ChannelConnectionCopyWith(_ChannelConnection value, $Res Function(_ChannelConnection) _then) = __$ChannelConnectionCopyWithImpl;
@override @useResult
$Res call({
 ChannelType type, ChannelConnectionStatus status, String? accountName, DateTime? lastSyncAt
});




}
/// @nodoc
class __$ChannelConnectionCopyWithImpl<$Res>
    implements _$ChannelConnectionCopyWith<$Res> {
  __$ChannelConnectionCopyWithImpl(this._self, this._then);

  final _ChannelConnection _self;
  final $Res Function(_ChannelConnection) _then;

/// Create a copy of ChannelConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? status = null,Object? accountName = freezed,Object? lastSyncAt = freezed,}) {
  return _then(_ChannelConnection(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChannelType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChannelConnectionStatus,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,lastSyncAt: freezed == lastSyncAt ? _self.lastSyncAt : lastSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
