// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hall.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Hall {

 String get id; String get name; String get slug; String get universityId;
/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HallCopyWith<Hall> get copyWith => _$HallCopyWithImpl<Hall>(this as Hall, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hall&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,slug,universityId);

@override
String toString() {
  return 'Hall(id: $id, name: $name, slug: $slug, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class $HallCopyWith<$Res>  {
  factory $HallCopyWith(Hall value, $Res Function(Hall) _then) = _$HallCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String universityId
});




}
/// @nodoc
class _$HallCopyWithImpl<$Res>
    implements $HallCopyWith<$Res> {
  _$HallCopyWithImpl(this._self, this._then);

  final Hall _self;
  final $Res Function(Hall) _then;

/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? universityId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Hall].
extension HallPatterns on Hall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hall value)  $default,){
final _that = this;
switch (_that) {
case _Hall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hall value)?  $default,){
final _that = this;
switch (_that) {
case _Hall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String universityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hall() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.universityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String universityId)  $default,) {final _that = this;
switch (_that) {
case _Hall():
return $default(_that.id,_that.name,_that.slug,_that.universityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String universityId)?  $default,) {final _that = this;
switch (_that) {
case _Hall() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.universityId);case _:
  return null;

}
}

}

/// @nodoc


class _Hall implements Hall {
  const _Hall({required this.id, required this.name, required this.slug, required this.universityId});
  

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String universityId;

/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HallCopyWith<_Hall> get copyWith => __$HallCopyWithImpl<_Hall>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hall&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,slug,universityId);

@override
String toString() {
  return 'Hall(id: $id, name: $name, slug: $slug, universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class _$HallCopyWith<$Res> implements $HallCopyWith<$Res> {
  factory _$HallCopyWith(_Hall value, $Res Function(_Hall) _then) = __$HallCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String universityId
});




}
/// @nodoc
class __$HallCopyWithImpl<$Res>
    implements _$HallCopyWith<$Res> {
  __$HallCopyWithImpl(this._self, this._then);

  final _Hall _self;
  final $Res Function(_Hall) _then;

/// Create a copy of Hall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? universityId = null,}) {
  return _then(_Hall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
