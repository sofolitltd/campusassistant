// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoutineModel {

 String get id; String get title;@JsonKey(name: 'image_url') String get imageUrl; String get time;@JsonKey(name: 'university_id') String get universityId;@JsonKey(name: 'department_id') String get departmentId;
/// Create a copy of RoutineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutineModelCopyWith<RoutineModel> get copyWith => _$RoutineModelCopyWithImpl<RoutineModel>(this as RoutineModel, _$identity);

  /// Serializes this RoutineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.time, time) || other.time == time)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,time,universityId,departmentId);

@override
String toString() {
  return 'RoutineModel(id: $id, title: $title, imageUrl: $imageUrl, time: $time, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class $RoutineModelCopyWith<$Res>  {
  factory $RoutineModelCopyWith(RoutineModel value, $Res Function(RoutineModel) _then) = _$RoutineModelCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'image_url') String imageUrl, String time,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class _$RoutineModelCopyWithImpl<$Res>
    implements $RoutineModelCopyWith<$Res> {
  _$RoutineModelCopyWithImpl(this._self, this._then);

  final RoutineModel _self;
  final $Res Function(RoutineModel) _then;

/// Create a copy of RoutineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? time = null,Object? universityId = null,Object? departmentId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutineModel].
extension RoutineModelPatterns on RoutineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutineModel value)  $default,){
final _that = this;
switch (_that) {
case _RoutineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutineModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoutineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'image_url')  String imageUrl,  String time, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutineModel() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.time,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'image_url')  String imageUrl,  String time, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId)  $default,) {final _that = this;
switch (_that) {
case _RoutineModel():
return $default(_that.id,_that.title,_that.imageUrl,_that.time,_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'image_url')  String imageUrl,  String time, @JsonKey(name: 'university_id')  String universityId, @JsonKey(name: 'department_id')  String departmentId)?  $default,) {final _that = this;
switch (_that) {
case _RoutineModel() when $default != null:
return $default(_that.id,_that.title,_that.imageUrl,_that.time,_that.universityId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutineModel extends RoutineModel {
  const _RoutineModel({required this.id, required this.title, @JsonKey(name: 'image_url') required this.imageUrl, required this.time, @JsonKey(name: 'university_id') required this.universityId, @JsonKey(name: 'department_id') required this.departmentId}): super._();
  factory _RoutineModel.fromJson(Map<String, dynamic> json) => _$RoutineModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override final  String time;
@override@JsonKey(name: 'university_id') final  String universityId;
@override@JsonKey(name: 'department_id') final  String departmentId;

/// Create a copy of RoutineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutineModelCopyWith<_RoutineModel> get copyWith => __$RoutineModelCopyWithImpl<_RoutineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutineModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.time, time) || other.time == time)&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,imageUrl,time,universityId,departmentId);

@override
String toString() {
  return 'RoutineModel(id: $id, title: $title, imageUrl: $imageUrl, time: $time, universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$RoutineModelCopyWith<$Res> implements $RoutineModelCopyWith<$Res> {
  factory _$RoutineModelCopyWith(_RoutineModel value, $Res Function(_RoutineModel) _then) = __$RoutineModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'image_url') String imageUrl, String time,@JsonKey(name: 'university_id') String universityId,@JsonKey(name: 'department_id') String departmentId
});




}
/// @nodoc
class __$RoutineModelCopyWithImpl<$Res>
    implements _$RoutineModelCopyWith<$Res> {
  __$RoutineModelCopyWithImpl(this._self, this._then);

  final _RoutineModel _self;
  final $Res Function(_RoutineModel) _then;

/// Create a copy of RoutineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? imageUrl = null,Object? time = null,Object? universityId = null,Object? departmentId = null,}) {
  return _then(_RoutineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
