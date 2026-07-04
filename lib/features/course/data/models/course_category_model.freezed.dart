// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseCategoryModel {

 String get id; String get name; int get order; String get departmentId; String get universityId;
/// Create a copy of CourseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCategoryModelCopyWith<CourseCategoryModel> get copyWith => _$CourseCategoryModelCopyWithImpl<CourseCategoryModel>(this as CourseCategoryModel, _$identity);

  /// Serializes this CourseCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order,departmentId,universityId);

@override
String toString() {
  return 'CourseCategoryModel(id: $id, name: $name, order: $order, departmentId: $departmentId, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class $CourseCategoryModelCopyWith<$Res>  {
  factory $CourseCategoryModelCopyWith(CourseCategoryModel value, $Res Function(CourseCategoryModel) _then) = _$CourseCategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, int order, String departmentId, String universityId
});




}
/// @nodoc
class _$CourseCategoryModelCopyWithImpl<$Res>
    implements $CourseCategoryModelCopyWith<$Res> {
  _$CourseCategoryModelCopyWithImpl(this._self, this._then);

  final CourseCategoryModel _self;
  final $Res Function(CourseCategoryModel) _then;

/// Create a copy of CourseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? order = null,Object? departmentId = null,Object? universityId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseCategoryModel].
extension CourseCategoryModelPatterns on CourseCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int order,  String departmentId,  String universityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.departmentId,_that.universityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int order,  String departmentId,  String universityId)  $default,) {final _that = this;
switch (_that) {
case _CourseCategoryModel():
return $default(_that.id,_that.name,_that.order,_that.departmentId,_that.universityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int order,  String departmentId,  String universityId)?  $default,) {final _that = this;
switch (_that) {
case _CourseCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.departmentId,_that.universityId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseCategoryModel extends CourseCategoryModel {
  const _CourseCategoryModel({required this.id, required this.name, required this.order, required this.departmentId, required this.universityId}): super._();
  factory _CourseCategoryModel.fromJson(Map<String, dynamic> json) => _$CourseCategoryModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  int order;
@override final  String departmentId;
@override final  String universityId;

/// Create a copy of CourseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCategoryModelCopyWith<_CourseCategoryModel> get copyWith => __$CourseCategoryModelCopyWithImpl<_CourseCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order,departmentId,universityId);

@override
String toString() {
  return 'CourseCategoryModel(id: $id, name: $name, order: $order, departmentId: $departmentId, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class _$CourseCategoryModelCopyWith<$Res> implements $CourseCategoryModelCopyWith<$Res> {
  factory _$CourseCategoryModelCopyWith(_CourseCategoryModel value, $Res Function(_CourseCategoryModel) _then) = __$CourseCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int order, String departmentId, String universityId
});




}
/// @nodoc
class __$CourseCategoryModelCopyWithImpl<$Res>
    implements _$CourseCategoryModelCopyWith<$Res> {
  __$CourseCategoryModelCopyWithImpl(this._self, this._then);

  final _CourseCategoryModel _self;
  final $Res Function(_CourseCategoryModel) _then;

/// Create a copy of CourseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,Object? departmentId = null,Object? universityId = null,}) {
  return _then(_CourseCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
