// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_teachers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetTeachersParams {

 String get universityId; String get departmentId; bool? get isPresent;
/// Create a copy of GetTeachersParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetTeachersParamsCopyWith<GetTeachersParams> get copyWith => _$GetTeachersParamsCopyWithImpl<GetTeachersParams>(this as GetTeachersParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetTeachersParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.isPresent, isPresent) || other.isPresent == isPresent));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,isPresent);

@override
String toString() {
  return 'GetTeachersParams(universityId: $universityId, departmentId: $departmentId, isPresent: $isPresent)';
}


}

/// @nodoc
abstract mixin class $GetTeachersParamsCopyWith<$Res>  {
  factory $GetTeachersParamsCopyWith(GetTeachersParams value, $Res Function(GetTeachersParams) _then) = _$GetTeachersParamsCopyWithImpl;
@useResult
$Res call({
 String universityId, String departmentId, bool? isPresent
});




}
/// @nodoc
class _$GetTeachersParamsCopyWithImpl<$Res>
    implements $GetTeachersParamsCopyWith<$Res> {
  _$GetTeachersParamsCopyWithImpl(this._self, this._then);

  final GetTeachersParams _self;
  final $Res Function(GetTeachersParams) _then;

/// Create a copy of GetTeachersParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? universityId = null,Object? departmentId = null,Object? isPresent = freezed,}) {
  return _then(_self.copyWith(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,isPresent: freezed == isPresent ? _self.isPresent : isPresent // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetTeachersParams].
extension GetTeachersParamsPatterns on GetTeachersParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetTeachersParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetTeachersParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetTeachersParams value)  $default,){
final _that = this;
switch (_that) {
case _GetTeachersParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetTeachersParams value)?  $default,){
final _that = this;
switch (_that) {
case _GetTeachersParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String universityId,  String departmentId,  bool? isPresent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetTeachersParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.isPresent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String universityId,  String departmentId,  bool? isPresent)  $default,) {final _that = this;
switch (_that) {
case _GetTeachersParams():
return $default(_that.universityId,_that.departmentId,_that.isPresent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String universityId,  String departmentId,  bool? isPresent)?  $default,) {final _that = this;
switch (_that) {
case _GetTeachersParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.isPresent);case _:
  return null;

}
}

}

/// @nodoc


class _GetTeachersParams implements GetTeachersParams {
  const _GetTeachersParams({required this.universityId, required this.departmentId, this.isPresent});
  

@override final  String universityId;
@override final  String departmentId;
@override final  bool? isPresent;

/// Create a copy of GetTeachersParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetTeachersParamsCopyWith<_GetTeachersParams> get copyWith => __$GetTeachersParamsCopyWithImpl<_GetTeachersParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetTeachersParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.isPresent, isPresent) || other.isPresent == isPresent));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,isPresent);

@override
String toString() {
  return 'GetTeachersParams(universityId: $universityId, departmentId: $departmentId, isPresent: $isPresent)';
}


}

/// @nodoc
abstract mixin class _$GetTeachersParamsCopyWith<$Res> implements $GetTeachersParamsCopyWith<$Res> {
  factory _$GetTeachersParamsCopyWith(_GetTeachersParams value, $Res Function(_GetTeachersParams) _then) = __$GetTeachersParamsCopyWithImpl;
@override @useResult
$Res call({
 String universityId, String departmentId, bool? isPresent
});




}
/// @nodoc
class __$GetTeachersParamsCopyWithImpl<$Res>
    implements _$GetTeachersParamsCopyWith<$Res> {
  __$GetTeachersParamsCopyWithImpl(this._self, this._then);

  final _GetTeachersParams _self;
  final $Res Function(_GetTeachersParams) _then;

/// Create a copy of GetTeachersParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? universityId = null,Object? departmentId = null,Object? isPresent = freezed,}) {
  return _then(_GetTeachersParams(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,isPresent: freezed == isPresent ? _self.isPresent : isPresent // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
