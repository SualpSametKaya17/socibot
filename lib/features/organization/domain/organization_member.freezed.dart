// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganizationMember {

 String get id; String get organizationId; String get userId; OrganizationRole get role; String get displayName; String? get email; String? get avatarUrl; DateTime get joinedAt; OrganizationMemberStatus get status;/// Null for a member who hasn't signed in since being invited.
 DateTime? get lastActiveAt;
/// Create a copy of OrganizationMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationMemberCopyWith<OrganizationMember> get copyWith => _$OrganizationMemberCopyWithImpl<OrganizationMember>(this as OrganizationMember, _$identity);

  /// Serializes this OrganizationMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationMember&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,userId,role,displayName,email,avatarUrl,joinedAt,status,lastActiveAt);

@override
String toString() {
  return 'OrganizationMember(id: $id, organizationId: $organizationId, userId: $userId, role: $role, displayName: $displayName, email: $email, avatarUrl: $avatarUrl, joinedAt: $joinedAt, status: $status, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $OrganizationMemberCopyWith<$Res>  {
  factory $OrganizationMemberCopyWith(OrganizationMember value, $Res Function(OrganizationMember) _then) = _$OrganizationMemberCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String userId, OrganizationRole role, String displayName, String? email, String? avatarUrl, DateTime joinedAt, OrganizationMemberStatus status, DateTime? lastActiveAt
});




}
/// @nodoc
class _$OrganizationMemberCopyWithImpl<$Res>
    implements $OrganizationMemberCopyWith<$Res> {
  _$OrganizationMemberCopyWithImpl(this._self, this._then);

  final OrganizationMember _self;
  final $Res Function(OrganizationMember) _then;

/// Create a copy of OrganizationMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? userId = null,Object? role = null,Object? displayName = null,Object? email = freezed,Object? avatarUrl = freezed,Object? joinedAt = null,Object? status = null,Object? lastActiveAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as OrganizationRole,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrganizationMemberStatus,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizationMember].
extension OrganizationMemberPatterns on OrganizationMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationMember value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationMember value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String userId,  OrganizationRole role,  String displayName,  String? email,  String? avatarUrl,  DateTime joinedAt,  OrganizationMemberStatus status,  DateTime? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationMember() when $default != null:
return $default(_that.id,_that.organizationId,_that.userId,_that.role,_that.displayName,_that.email,_that.avatarUrl,_that.joinedAt,_that.status,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String userId,  OrganizationRole role,  String displayName,  String? email,  String? avatarUrl,  DateTime joinedAt,  OrganizationMemberStatus status,  DateTime? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _OrganizationMember():
return $default(_that.id,_that.organizationId,_that.userId,_that.role,_that.displayName,_that.email,_that.avatarUrl,_that.joinedAt,_that.status,_that.lastActiveAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String userId,  OrganizationRole role,  String displayName,  String? email,  String? avatarUrl,  DateTime joinedAt,  OrganizationMemberStatus status,  DateTime? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationMember() when $default != null:
return $default(_that.id,_that.organizationId,_that.userId,_that.role,_that.displayName,_that.email,_that.avatarUrl,_that.joinedAt,_that.status,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizationMember implements OrganizationMember {
  const _OrganizationMember({required this.id, required this.organizationId, required this.userId, required this.role, required this.displayName, this.email, this.avatarUrl, required this.joinedAt, this.status = OrganizationMemberStatus.active, this.lastActiveAt});
  factory _OrganizationMember.fromJson(Map<String, dynamic> json) => _$OrganizationMemberFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String userId;
@override final  OrganizationRole role;
@override final  String displayName;
@override final  String? email;
@override final  String? avatarUrl;
@override final  DateTime joinedAt;
@override@JsonKey() final  OrganizationMemberStatus status;
/// Null for a member who hasn't signed in since being invited.
@override final  DateTime? lastActiveAt;

/// Create a copy of OrganizationMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationMemberCopyWith<_OrganizationMember> get copyWith => __$OrganizationMemberCopyWithImpl<_OrganizationMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationMember&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organizationId,userId,role,displayName,email,avatarUrl,joinedAt,status,lastActiveAt);

@override
String toString() {
  return 'OrganizationMember(id: $id, organizationId: $organizationId, userId: $userId, role: $role, displayName: $displayName, email: $email, avatarUrl: $avatarUrl, joinedAt: $joinedAt, status: $status, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$OrganizationMemberCopyWith<$Res> implements $OrganizationMemberCopyWith<$Res> {
  factory _$OrganizationMemberCopyWith(_OrganizationMember value, $Res Function(_OrganizationMember) _then) = __$OrganizationMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String userId, OrganizationRole role, String displayName, String? email, String? avatarUrl, DateTime joinedAt, OrganizationMemberStatus status, DateTime? lastActiveAt
});




}
/// @nodoc
class __$OrganizationMemberCopyWithImpl<$Res>
    implements _$OrganizationMemberCopyWith<$Res> {
  __$OrganizationMemberCopyWithImpl(this._self, this._then);

  final _OrganizationMember _self;
  final $Res Function(_OrganizationMember) _then;

/// Create a copy of OrganizationMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? userId = null,Object? role = null,Object? displayName = null,Object? email = freezed,Object? avatarUrl = freezed,Object? joinedAt = null,Object? status = null,Object? lastActiveAt = freezed,}) {
  return _then(_OrganizationMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as OrganizationRole,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrganizationMemberStatus,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
