// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedbackItemModel {

 String get id; String get category; String get subject; String get message;@JsonKey(name: 'attachment_url') String? get attachmentUrl; String get status;@JsonKey(name: 'admin_reply') String? get adminReply;@JsonKey(name: 'replied_at') String? get repliedAt;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of FeedbackItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackItemModelCopyWith<FeedbackItemModel> get copyWith => _$FeedbackItemModelCopyWithImpl<FeedbackItemModel>(this as FeedbackItemModel, _$identity);

  /// Serializes this FeedbackItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedbackItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.attachmentUrl, _this.attachmentUrl) || other.attachmentUrl == _this.attachmentUrl)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.adminReply, _this.adminReply) || other.adminReply == _this.adminReply)&&(identical(other.repliedAt, _this.repliedAt) || other.repliedAt == _this.repliedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedbackItemModel;
  return Object.hash(runtimeType,_this.id,_this.category,_this.subject,_this.message,_this.attachmentUrl,_this.status,_this.adminReply,_this.repliedAt,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as FeedbackItemModel;
  return 'FeedbackItemModel(id: ${_this.id}, category: ${_this.category}, subject: ${_this.subject}, message: ${_this.message}, attachmentUrl: ${_this.attachmentUrl}, status: ${_this.status}, adminReply: ${_this.adminReply}, repliedAt: ${_this.repliedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FeedbackItemModelCopyWith<$Res>  {
  factory $FeedbackItemModelCopyWith(FeedbackItemModel value, $Res Function(FeedbackItemModel) _then) = _$FeedbackItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String category, String subject, String message,@JsonKey(name: 'attachment_url') String? attachmentUrl, String status,@JsonKey(name: 'admin_reply') String? adminReply,@JsonKey(name: 'replied_at') String? repliedAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$FeedbackItemModelCopyWithImpl<$Res>
    implements $FeedbackItemModelCopyWith<$Res> {
  _$FeedbackItemModelCopyWithImpl(this._self, this._then);

  final FeedbackItemModel _self;
  final $Res Function(FeedbackItemModel) _then;

/// Create a copy of FeedbackItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? subject = null,Object? message = null,Object? attachmentUrl = freezed,Object? status = null,Object? adminReply = freezed,Object? repliedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(FeedbackItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,adminReply: freezed == adminReply ? _self.adminReply : adminReply // ignore: cast_nullable_to_non_nullable
as String?,repliedAt: freezed == repliedAt ? _self.repliedAt : repliedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackItemModel].
extension FeedbackItemModelPatterns on FeedbackItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackItemModel value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  String subject,  String message, @JsonKey(name: 'attachment_url')  String? attachmentUrl,  String status, @JsonKey(name: 'admin_reply')  String? adminReply, @JsonKey(name: 'replied_at')  String? repliedAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackItemModel() when $default != null:
return $default(_that.id,_that.category,_that.subject,_that.message,_that.attachmentUrl,_that.status,_that.adminReply,_that.repliedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  String subject,  String message, @JsonKey(name: 'attachment_url')  String? attachmentUrl,  String status, @JsonKey(name: 'admin_reply')  String? adminReply, @JsonKey(name: 'replied_at')  String? repliedAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FeedbackItemModel():
return $default(_that.id,_that.category,_that.subject,_that.message,_that.attachmentUrl,_that.status,_that.adminReply,_that.repliedAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  String subject,  String message, @JsonKey(name: 'attachment_url')  String? attachmentUrl,  String status, @JsonKey(name: 'admin_reply')  String? adminReply, @JsonKey(name: 'replied_at')  String? repliedAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackItemModel() when $default != null:
return $default(_that.id,_that.category,_that.subject,_that.message,_that.attachmentUrl,_that.status,_that.adminReply,_that.repliedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedbackItemModel extends FeedbackItemModel {
  const _FeedbackItemModel({required this.id, required this.category, required this.subject, required this.message, @JsonKey(name: 'attachment_url') this.attachmentUrl, this.status = 'pending', @JsonKey(name: 'admin_reply') this.adminReply, @JsonKey(name: 'replied_at') this.repliedAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): super._();
  factory _FeedbackItemModel.fromJson(Map<String, dynamic> json) => _$FeedbackItemModelFromJson(json);

@override final  String id;
@override final  String category;
@override final  String subject;
@override final  String message;
@override@JsonKey(name: 'attachment_url') final  String? attachmentUrl;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'admin_reply') final  String? adminReply;
@override@JsonKey(name: 'replied_at') final  String? repliedAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of FeedbackItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackItemModelCopyWith<_FeedbackItemModel> get copyWith => __$FeedbackItemModelCopyWithImpl<_FeedbackItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedbackItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.message, message) || other.message == message)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.adminReply, adminReply) || other.adminReply == adminReply)&&(identical(other.repliedAt, repliedAt) || other.repliedAt == repliedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,category,subject,message,attachmentUrl,status,adminReply,repliedAt,createdAt,updatedAt);
}

@override
String toString() {
    return 'FeedbackItemModel(id: $id, category: $category, subject: $subject, message: $message, attachmentUrl: $attachmentUrl, status: $status, adminReply: $adminReply, repliedAt: $repliedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FeedbackItemModelCopyWith<$Res> implements $FeedbackItemModelCopyWith<$Res> {
  factory _$FeedbackItemModelCopyWith(_FeedbackItemModel value, $Res Function(_FeedbackItemModel) _then) = __$FeedbackItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, String subject, String message,@JsonKey(name: 'attachment_url') String? attachmentUrl, String status,@JsonKey(name: 'admin_reply') String? adminReply,@JsonKey(name: 'replied_at') String? repliedAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$FeedbackItemModelCopyWithImpl<$Res>
    implements _$FeedbackItemModelCopyWith<$Res> {
  __$FeedbackItemModelCopyWithImpl(this._self, this._then);

  final _FeedbackItemModel _self;
  final $Res Function(_FeedbackItemModel) _then;

/// Create a copy of FeedbackItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? subject = null,Object? message = null,Object? attachmentUrl = freezed,Object? status = null,Object? adminReply = freezed,Object? repliedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_FeedbackItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,adminReply: freezed == adminReply ? _self.adminReply : adminReply // ignore: cast_nullable_to_non_nullable
as String?,repliedAt: freezed == repliedAt ? _self.repliedAt : repliedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
