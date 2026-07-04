// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseCategory {

 String get id; String get name; int get order; String get departmentId; String get universityId;
/// Create a copy of CourseCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCategoryCopyWith<CourseCategory> get copyWith => _$CourseCategoryCopyWithImpl<CourseCategory>(this as CourseCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,order,departmentId,universityId);

@override
String toString() {
  return 'CourseCategory(id: $id, name: $name, order: $order, departmentId: $departmentId, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class $CourseCategoryCopyWith<$Res>  {
  factory $CourseCategoryCopyWith(CourseCategory value, $Res Function(CourseCategory) _then) = _$CourseCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, int order, String departmentId, String universityId
});




}
/// @nodoc
class _$CourseCategoryCopyWithImpl<$Res>
    implements $CourseCategoryCopyWith<$Res> {
  _$CourseCategoryCopyWithImpl(this._self, this._then);

  final CourseCategory _self;
  final $Res Function(CourseCategory) _then;

/// Create a copy of CourseCategory
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


/// Adds pattern-matching-related methods to [CourseCategory].
extension CourseCategoryPatterns on CourseCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseCategory value)  $default,){
final _that = this;
switch (_that) {
case _CourseCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseCategory value)?  $default,){
final _that = this;
switch (_that) {
case _CourseCategory() when $default != null:
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
case _CourseCategory() when $default != null:
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
case _CourseCategory():
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
case _CourseCategory() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.departmentId,_that.universityId);case _:
  return null;

}
}

}

/// @nodoc


class _CourseCategory implements CourseCategory {
  const _CourseCategory({required this.id, required this.name, required this.order, required this.departmentId, required this.universityId});
  

@override final  String id;
@override final  String name;
@override final  int order;
@override final  String departmentId;
@override final  String universityId;

/// Create a copy of CourseCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCategoryCopyWith<_CourseCategory> get copyWith => __$CourseCategoryCopyWithImpl<_CourseCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,order,departmentId,universityId);

@override
String toString() {
  return 'CourseCategory(id: $id, name: $name, order: $order, departmentId: $departmentId, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class _$CourseCategoryCopyWith<$Res> implements $CourseCategoryCopyWith<$Res> {
  factory _$CourseCategoryCopyWith(_CourseCategory value, $Res Function(_CourseCategory) _then) = __$CourseCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int order, String departmentId, String universityId
});




}
/// @nodoc
class __$CourseCategoryCopyWithImpl<$Res>
    implements _$CourseCategoryCopyWith<$Res> {
  __$CourseCategoryCopyWithImpl(this._self, this._then);

  final _CourseCategory _self;
  final $Res Function(_CourseCategory) _then;

/// Create a copy of CourseCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,Object? departmentId = null,Object? universityId = null,}) {
  return _then(_CourseCategory(
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
