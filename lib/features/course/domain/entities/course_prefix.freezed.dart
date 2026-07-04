// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_prefix.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoursePrefix {

 String get id; String get prefix; String get description; String get departmentId; String get universityId;
/// Create a copy of CoursePrefix
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoursePrefixCopyWith<CoursePrefix> get copyWith => _$CoursePrefixCopyWithImpl<CoursePrefix>(this as CoursePrefix, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoursePrefix&&(identical(other.id, id) || other.id == id)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.description, description) || other.description == description)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,id,prefix,description,departmentId,universityId);

@override
String toString() {
  return 'CoursePrefix(id: $id, prefix: $prefix, description: $description, departmentId: $departmentId, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class $CoursePrefixCopyWith<$Res>  {
  factory $CoursePrefixCopyWith(CoursePrefix value, $Res Function(CoursePrefix) _then) = _$CoursePrefixCopyWithImpl;
@useResult
$Res call({
 String id, String prefix, String description, String departmentId, String universityId
});




}
/// @nodoc
class _$CoursePrefixCopyWithImpl<$Res>
    implements $CoursePrefixCopyWith<$Res> {
  _$CoursePrefixCopyWithImpl(this._self, this._then);

  final CoursePrefix _self;
  final $Res Function(CoursePrefix) _then;

/// Create a copy of CoursePrefix
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? prefix = null,Object? description = null,Object? departmentId = null,Object? universityId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CoursePrefix].
extension CoursePrefixPatterns on CoursePrefix {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoursePrefix value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoursePrefix() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoursePrefix value)  $default,){
final _that = this;
switch (_that) {
case _CoursePrefix():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoursePrefix value)?  $default,){
final _that = this;
switch (_that) {
case _CoursePrefix() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String prefix,  String description,  String departmentId,  String universityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoursePrefix() when $default != null:
return $default(_that.id,_that.prefix,_that.description,_that.departmentId,_that.universityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String prefix,  String description,  String departmentId,  String universityId)  $default,) {final _that = this;
switch (_that) {
case _CoursePrefix():
return $default(_that.id,_that.prefix,_that.description,_that.departmentId,_that.universityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String prefix,  String description,  String departmentId,  String universityId)?  $default,) {final _that = this;
switch (_that) {
case _CoursePrefix() when $default != null:
return $default(_that.id,_that.prefix,_that.description,_that.departmentId,_that.universityId);case _:
  return null;

}
}

}

/// @nodoc


class _CoursePrefix implements CoursePrefix {
  const _CoursePrefix({required this.id, required this.prefix, required this.description, required this.departmentId, required this.universityId});
  

@override final  String id;
@override final  String prefix;
@override final  String description;
@override final  String departmentId;
@override final  String universityId;

/// Create a copy of CoursePrefix
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoursePrefixCopyWith<_CoursePrefix> get copyWith => __$CoursePrefixCopyWithImpl<_CoursePrefix>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoursePrefix&&(identical(other.id, id) || other.id == id)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.description, description) || other.description == description)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,id,prefix,description,departmentId,universityId);

@override
String toString() {
  return 'CoursePrefix(id: $id, prefix: $prefix, description: $description, departmentId: $departmentId, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class _$CoursePrefixCopyWith<$Res> implements $CoursePrefixCopyWith<$Res> {
  factory _$CoursePrefixCopyWith(_CoursePrefix value, $Res Function(_CoursePrefix) _then) = __$CoursePrefixCopyWithImpl;
@override @useResult
$Res call({
 String id, String prefix, String description, String departmentId, String universityId
});




}
/// @nodoc
class __$CoursePrefixCopyWithImpl<$Res>
    implements _$CoursePrefixCopyWith<$Res> {
  __$CoursePrefixCopyWithImpl(this._self, this._then);

  final _CoursePrefix _self;
  final $Res Function(_CoursePrefix) _then;

/// Create a copy of CoursePrefix
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? prefix = null,Object? description = null,Object? departmentId = null,Object? universityId = null,}) {
  return _then(_CoursePrefix(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
