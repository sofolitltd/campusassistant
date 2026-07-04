// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_staff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetStaffParams {

 String get universityId; String get departmentId;
/// Create a copy of GetStaffParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetStaffParamsCopyWith<GetStaffParams> get copyWith => _$GetStaffParamsCopyWithImpl<GetStaffParams>(this as GetStaffParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetStaffParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId);

@override
String toString() {
  return 'GetStaffParams(universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class $GetStaffParamsCopyWith<$Res>  {
  factory $GetStaffParamsCopyWith(GetStaffParams value, $Res Function(GetStaffParams) _then) = _$GetStaffParamsCopyWithImpl;
@useResult
$Res call({
 String universityId, String departmentId
});




}
/// @nodoc
class _$GetStaffParamsCopyWithImpl<$Res>
    implements $GetStaffParamsCopyWith<$Res> {
  _$GetStaffParamsCopyWithImpl(this._self, this._then);

  final GetStaffParams _self;
  final $Res Function(GetStaffParams) _then;

/// Create a copy of GetStaffParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? universityId = null,Object? departmentId = null,}) {
  return _then(_self.copyWith(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetStaffParams].
extension GetStaffParamsPatterns on GetStaffParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetStaffParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetStaffParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetStaffParams value)  $default,){
final _that = this;
switch (_that) {
case _GetStaffParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetStaffParams value)?  $default,){
final _that = this;
switch (_that) {
case _GetStaffParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String universityId,  String departmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetStaffParams() when $default != null:
return $default(_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String universityId,  String departmentId)  $default,) {final _that = this;
switch (_that) {
case _GetStaffParams():
return $default(_that.universityId,_that.departmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String universityId,  String departmentId)?  $default,) {final _that = this;
switch (_that) {
case _GetStaffParams() when $default != null:
return $default(_that.universityId,_that.departmentId);case _:
  return null;

}
}

}

/// @nodoc


class _GetStaffParams implements GetStaffParams {
  const _GetStaffParams({required this.universityId, required this.departmentId});
  

@override final  String universityId;
@override final  String departmentId;

/// Create a copy of GetStaffParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetStaffParamsCopyWith<_GetStaffParams> get copyWith => __$GetStaffParamsCopyWithImpl<_GetStaffParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetStaffParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId);

@override
String toString() {
  return 'GetStaffParams(universityId: $universityId, departmentId: $departmentId)';
}


}

/// @nodoc
abstract mixin class _$GetStaffParamsCopyWith<$Res> implements $GetStaffParamsCopyWith<$Res> {
  factory _$GetStaffParamsCopyWith(_GetStaffParams value, $Res Function(_GetStaffParams) _then) = __$GetStaffParamsCopyWithImpl;
@override @useResult
$Res call({
 String universityId, String departmentId
});




}
/// @nodoc
class __$GetStaffParamsCopyWithImpl<$Res>
    implements _$GetStaffParamsCopyWith<$Res> {
  __$GetStaffParamsCopyWithImpl(this._self, this._then);

  final _GetStaffParams _self;
  final $Res Function(_GetStaffParams) _then;

/// Create a copy of GetStaffParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? universityId = null,Object? departmentId = null,}) {
  return _then(_GetStaffParams(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
