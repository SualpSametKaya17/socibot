// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Conversation {

 String get id; String get contactName; String? get contactAvatarUrl; ChannelType get channel; ConversationStatus get status; String? get lastMessagePreview; DateTime? get lastMessageAt; int get unreadCount;// Mock-only for now — a real "assigned_to" column/UI lands in the
// conversation-assignment stage. Null means unassigned.
 String? get assignedAgentName;// Denormalized from the message thread's last entry — lets the list
// derive "unreplied" (customer waiting on us) honestly, without a
// fake status the data model doesn't actually track.
 MessageDirection? get lastMessageDirection;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactAvatarUrl, contactAvatarUrl) || other.contactAvatarUrl == contactAvatarUrl)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.assignedAgentName, assignedAgentName) || other.assignedAgentName == assignedAgentName)&&(identical(other.lastMessageDirection, lastMessageDirection) || other.lastMessageDirection == lastMessageDirection));
}


@override
int get hashCode => Object.hash(runtimeType,id,contactName,contactAvatarUrl,channel,status,lastMessagePreview,lastMessageAt,unreadCount,assignedAgentName,lastMessageDirection);

@override
String toString() {
  return 'Conversation(id: $id, contactName: $contactName, contactAvatarUrl: $contactAvatarUrl, channel: $channel, status: $status, lastMessagePreview: $lastMessagePreview, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount, assignedAgentName: $assignedAgentName, lastMessageDirection: $lastMessageDirection)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 String id, String contactName, String? contactAvatarUrl, ChannelType channel, ConversationStatus status, String? lastMessagePreview, DateTime? lastMessageAt, int unreadCount, String? assignedAgentName, MessageDirection? lastMessageDirection
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contactName = null,Object? contactAvatarUrl = freezed,Object? channel = null,Object? status = null,Object? lastMessagePreview = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,Object? assignedAgentName = freezed,Object? lastMessageDirection = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,contactAvatarUrl: freezed == contactAvatarUrl ? _self.contactAvatarUrl : contactAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as ChannelType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConversationStatus,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,assignedAgentName: freezed == assignedAgentName ? _self.assignedAgentName : assignedAgentName // ignore: cast_nullable_to_non_nullable
as String?,lastMessageDirection: freezed == lastMessageDirection ? _self.lastMessageDirection : lastMessageDirection // ignore: cast_nullable_to_non_nullable
as MessageDirection?,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contactName,  String? contactAvatarUrl,  ChannelType channel,  ConversationStatus status,  String? lastMessagePreview,  DateTime? lastMessageAt,  int unreadCount,  String? assignedAgentName,  MessageDirection? lastMessageDirection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.contactName,_that.contactAvatarUrl,_that.channel,_that.status,_that.lastMessagePreview,_that.lastMessageAt,_that.unreadCount,_that.assignedAgentName,_that.lastMessageDirection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contactName,  String? contactAvatarUrl,  ChannelType channel,  ConversationStatus status,  String? lastMessagePreview,  DateTime? lastMessageAt,  int unreadCount,  String? assignedAgentName,  MessageDirection? lastMessageDirection)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.contactName,_that.contactAvatarUrl,_that.channel,_that.status,_that.lastMessagePreview,_that.lastMessageAt,_that.unreadCount,_that.assignedAgentName,_that.lastMessageDirection);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contactName,  String? contactAvatarUrl,  ChannelType channel,  ConversationStatus status,  String? lastMessagePreview,  DateTime? lastMessageAt,  int unreadCount,  String? assignedAgentName,  MessageDirection? lastMessageDirection)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.contactName,_that.contactAvatarUrl,_that.channel,_that.status,_that.lastMessagePreview,_that.lastMessageAt,_that.unreadCount,_that.assignedAgentName,_that.lastMessageDirection);case _:
  return null;

}
}

}

/// @nodoc


class _Conversation implements Conversation {
  const _Conversation({required this.id, required this.contactName, this.contactAvatarUrl, required this.channel, required this.status, this.lastMessagePreview, this.lastMessageAt, this.unreadCount = 0, this.assignedAgentName, this.lastMessageDirection});
  

@override final  String id;
@override final  String contactName;
@override final  String? contactAvatarUrl;
@override final  ChannelType channel;
@override final  ConversationStatus status;
@override final  String? lastMessagePreview;
@override final  DateTime? lastMessageAt;
@override@JsonKey() final  int unreadCount;
// Mock-only for now — a real "assigned_to" column/UI lands in the
// conversation-assignment stage. Null means unassigned.
@override final  String? assignedAgentName;
// Denormalized from the message thread's last entry — lets the list
// derive "unreplied" (customer waiting on us) honestly, without a
// fake status the data model doesn't actually track.
@override final  MessageDirection? lastMessageDirection;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactAvatarUrl, contactAvatarUrl) || other.contactAvatarUrl == contactAvatarUrl)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastMessagePreview, lastMessagePreview) || other.lastMessagePreview == lastMessagePreview)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.assignedAgentName, assignedAgentName) || other.assignedAgentName == assignedAgentName)&&(identical(other.lastMessageDirection, lastMessageDirection) || other.lastMessageDirection == lastMessageDirection));
}


@override
int get hashCode => Object.hash(runtimeType,id,contactName,contactAvatarUrl,channel,status,lastMessagePreview,lastMessageAt,unreadCount,assignedAgentName,lastMessageDirection);

@override
String toString() {
  return 'Conversation(id: $id, contactName: $contactName, contactAvatarUrl: $contactAvatarUrl, channel: $channel, status: $status, lastMessagePreview: $lastMessagePreview, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount, assignedAgentName: $assignedAgentName, lastMessageDirection: $lastMessageDirection)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String contactName, String? contactAvatarUrl, ChannelType channel, ConversationStatus status, String? lastMessagePreview, DateTime? lastMessageAt, int unreadCount, String? assignedAgentName, MessageDirection? lastMessageDirection
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contactName = null,Object? contactAvatarUrl = freezed,Object? channel = null,Object? status = null,Object? lastMessagePreview = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,Object? assignedAgentName = freezed,Object? lastMessageDirection = freezed,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,contactAvatarUrl: freezed == contactAvatarUrl ? _self.contactAvatarUrl : contactAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as ChannelType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConversationStatus,lastMessagePreview: freezed == lastMessagePreview ? _self.lastMessagePreview : lastMessagePreview // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,assignedAgentName: freezed == assignedAgentName ? _self.assignedAgentName : assignedAgentName // ignore: cast_nullable_to_non_nullable
as String?,lastMessageDirection: freezed == lastMessageDirection ? _self.lastMessageDirection : lastMessageDirection // ignore: cast_nullable_to_non_nullable
as MessageDirection?,
  ));
}


}

// dart format on
