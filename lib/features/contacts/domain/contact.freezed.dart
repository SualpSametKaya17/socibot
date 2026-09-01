// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Contact {

 String get id; String get displayName; String? get avatarUrl; String? get email; String? get phone; String? get company; String? get location; ChannelType get primaryChannel;// Mock-data convenience only — lets "View conversation" jump straight
// to it. The real schema points the other way (conversations ->
// contact_id); a real contact can have several conversations.
 String get conversationId; DateTime? get lastContactedAt;
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactCopyWith<Contact> get copyWith => _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contact&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.company, company) || other.company == company)&&(identical(other.location, location) || other.location == location)&&(identical(other.primaryChannel, primaryChannel) || other.primaryChannel == primaryChannel)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.lastContactedAt, lastContactedAt) || other.lastContactedAt == lastContactedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarUrl,email,phone,company,location,primaryChannel,conversationId,lastContactedAt);

@override
String toString() {
  return 'Contact(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, email: $email, phone: $phone, company: $company, location: $location, primaryChannel: $primaryChannel, conversationId: $conversationId, lastContactedAt: $lastContactedAt)';
}


}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res>  {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) = _$ContactCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String? avatarUrl, String? email, String? phone, String? company, String? location, ChannelType primaryChannel, String conversationId, DateTime? lastContactedAt
});




}
/// @nodoc
class _$ContactCopyWithImpl<$Res>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._self, this._then);

  final Contact _self;
  final $Res Function(Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? avatarUrl = freezed,Object? email = freezed,Object? phone = freezed,Object? company = freezed,Object? location = freezed,Object? primaryChannel = null,Object? conversationId = null,Object? lastContactedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,primaryChannel: null == primaryChannel ? _self.primaryChannel : primaryChannel // ignore: cast_nullable_to_non_nullable
as ChannelType,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,lastContactedAt: freezed == lastContactedAt ? _self.lastContactedAt : lastContactedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Contact].
extension ContactPatterns on Contact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contact value)  $default,){
final _that = this;
switch (_that) {
case _Contact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contact value)?  $default,){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String? avatarUrl,  String? email,  String? phone,  String? company,  String? location,  ChannelType primaryChannel,  String conversationId,  DateTime? lastContactedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarUrl,_that.email,_that.phone,_that.company,_that.location,_that.primaryChannel,_that.conversationId,_that.lastContactedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String? avatarUrl,  String? email,  String? phone,  String? company,  String? location,  ChannelType primaryChannel,  String conversationId,  DateTime? lastContactedAt)  $default,) {final _that = this;
switch (_that) {
case _Contact():
return $default(_that.id,_that.displayName,_that.avatarUrl,_that.email,_that.phone,_that.company,_that.location,_that.primaryChannel,_that.conversationId,_that.lastContactedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String? avatarUrl,  String? email,  String? phone,  String? company,  String? location,  ChannelType primaryChannel,  String conversationId,  DateTime? lastContactedAt)?  $default,) {final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarUrl,_that.email,_that.phone,_that.company,_that.location,_that.primaryChannel,_that.conversationId,_that.lastContactedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Contact implements Contact {
  const _Contact({required this.id, required this.displayName, this.avatarUrl, this.email, this.phone, this.company, this.location, required this.primaryChannel, required this.conversationId, this.lastContactedAt});
  

@override final  String id;
@override final  String displayName;
@override final  String? avatarUrl;
@override final  String? email;
@override final  String? phone;
@override final  String? company;
@override final  String? location;
@override final  ChannelType primaryChannel;
// Mock-data convenience only — lets "View conversation" jump straight
// to it. The real schema points the other way (conversations ->
// contact_id); a real contact can have several conversations.
@override final  String conversationId;
@override final  DateTime? lastContactedAt;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactCopyWith<_Contact> get copyWith => __$ContactCopyWithImpl<_Contact>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contact&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.company, company) || other.company == company)&&(identical(other.location, location) || other.location == location)&&(identical(other.primaryChannel, primaryChannel) || other.primaryChannel == primaryChannel)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.lastContactedAt, lastContactedAt) || other.lastContactedAt == lastContactedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarUrl,email,phone,company,location,primaryChannel,conversationId,lastContactedAt);

@override
String toString() {
  return 'Contact(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, email: $email, phone: $phone, company: $company, location: $location, primaryChannel: $primaryChannel, conversationId: $conversationId, lastContactedAt: $lastContactedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$ContactCopyWith(_Contact value, $Res Function(_Contact) _then) = __$ContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String? avatarUrl, String? email, String? phone, String? company, String? location, ChannelType primaryChannel, String conversationId, DateTime? lastContactedAt
});




}
/// @nodoc
class __$ContactCopyWithImpl<$Res>
    implements _$ContactCopyWith<$Res> {
  __$ContactCopyWithImpl(this._self, this._then);

  final _Contact _self;
  final $Res Function(_Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? avatarUrl = freezed,Object? email = freezed,Object? phone = freezed,Object? company = freezed,Object? location = freezed,Object? primaryChannel = null,Object? conversationId = null,Object? lastContactedAt = freezed,}) {
  return _then(_Contact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,primaryChannel: null == primaryChannel ? _self.primaryChannel : primaryChannel // ignore: cast_nullable_to_non_nullable
as ChannelType,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,lastContactedAt: freezed == lastContactedAt ? _self.lastContactedAt : lastContactedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
