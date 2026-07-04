// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookmarkModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'entity_type') String get entityType;@JsonKey(name: 'entity_id') String get entityId;
/// Create a copy of BookmarkModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkModelCopyWith<BookmarkModel> get copyWith => _$BookmarkModelCopyWithImpl<BookmarkModel>(this as BookmarkModel, _$identity);

  /// Serializes this BookmarkModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,entityType,entityId);

@override
String toString() {
  return 'BookmarkModel(id: $id, userId: $userId, entityType: $entityType, entityId: $entityId)';
}


}

/// @nodoc
abstract mixin class $BookmarkModelCopyWith<$Res>  {
  factory $BookmarkModelCopyWith(BookmarkModel value, $Res Function(BookmarkModel) _then) = _$BookmarkModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String entityId
});




}
/// @nodoc
class _$BookmarkModelCopyWithImpl<$Res>
    implements $BookmarkModelCopyWith<$Res> {
  _$BookmarkModelCopyWithImpl(this._self, this._then);

  final BookmarkModel _self;
  final $Res Function(BookmarkModel) _then;

/// Create a copy of BookmarkModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? entityType = null,Object? entityId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarkModel].
extension BookmarkModelPatterns on BookmarkModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarkModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarkModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarkModel value)  $default,){
final _that = this;
switch (_that) {
case _BookmarkModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarkModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarkModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String entityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarkModel() when $default != null:
return $default(_that.id,_that.userId,_that.entityType,_that.entityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String entityId)  $default,) {final _that = this;
switch (_that) {
case _BookmarkModel():
return $default(_that.id,_that.userId,_that.entityType,_that.entityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String entityId)?  $default,) {final _that = this;
switch (_that) {
case _BookmarkModel() when $default != null:
return $default(_that.id,_that.userId,_that.entityType,_that.entityId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookmarkModel extends BookmarkModel {
  const _BookmarkModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'entity_type') required this.entityType, @JsonKey(name: 'entity_id') required this.entityId}): super._();
  factory _BookmarkModel.fromJson(Map<String, dynamic> json) => _$BookmarkModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'entity_type') final  String entityType;
@override@JsonKey(name: 'entity_id') final  String entityId;

/// Create a copy of BookmarkModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkModelCopyWith<_BookmarkModel> get copyWith => __$BookmarkModelCopyWithImpl<_BookmarkModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookmarkModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarkModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,entityType,entityId);

@override
String toString() {
  return 'BookmarkModel(id: $id, userId: $userId, entityType: $entityType, entityId: $entityId)';
}


}

/// @nodoc
abstract mixin class _$BookmarkModelCopyWith<$Res> implements $BookmarkModelCopyWith<$Res> {
  factory _$BookmarkModelCopyWith(_BookmarkModel value, $Res Function(_BookmarkModel) _then) = __$BookmarkModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String entityId
});




}
/// @nodoc
class __$BookmarkModelCopyWithImpl<$Res>
    implements _$BookmarkModelCopyWith<$Res> {
  __$BookmarkModelCopyWithImpl(this._self, this._then);

  final _BookmarkModel _self;
  final $Res Function(_BookmarkModel) _then;

/// Create a copy of BookmarkModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? entityType = null,Object? entityId = null,}) {
  return _then(_BookmarkModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
