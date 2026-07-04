// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_clubs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetClubsParams {

 String get universityId; String? get departmentId; String get type;
/// Create a copy of GetClubsParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetClubsParamsCopyWith<GetClubsParams> get copyWith => _$GetClubsParamsCopyWithImpl<GetClubsParams>(this as GetClubsParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetClubsParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,type);

@override
String toString() {
  return 'GetClubsParams(universityId: $universityId, departmentId: $departmentId, type: $type)';
}


}

/// @nodoc
abstract mixin class $GetClubsParamsCopyWith<$Res>  {
  factory $GetClubsParamsCopyWith(GetClubsParams value, $Res Function(GetClubsParams) _then) = _$GetClubsParamsCopyWithImpl;
@useResult
$Res call({
 String universityId, String? departmentId, String type
});




}
/// @nodoc
class _$GetClubsParamsCopyWithImpl<$Res>
    implements $GetClubsParamsCopyWith<$Res> {
  _$GetClubsParamsCopyWithImpl(this._self, this._then);

  final GetClubsParams _self;
  final $Res Function(GetClubsParams) _then;

/// Create a copy of GetClubsParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? universityId = null,Object? departmentId = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetClubsParams].
extension GetClubsParamsPatterns on GetClubsParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetClubsParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetClubsParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetClubsParams value)  $default,){
final _that = this;
switch (_that) {
case _GetClubsParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetClubsParams value)?  $default,){
final _that = this;
switch (_that) {
case _GetClubsParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String universityId,  String? departmentId,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetClubsParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String universityId,  String? departmentId,  String type)  $default,) {final _that = this;
switch (_that) {
case _GetClubsParams():
return $default(_that.universityId,_that.departmentId,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String universityId,  String? departmentId,  String type)?  $default,) {final _that = this;
switch (_that) {
case _GetClubsParams() when $default != null:
return $default(_that.universityId,_that.departmentId,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _GetClubsParams implements GetClubsParams {
  const _GetClubsParams({required this.universityId, this.departmentId, required this.type});
  

@override final  String universityId;
@override final  String? departmentId;
@override final  String type;

/// Create a copy of GetClubsParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetClubsParamsCopyWith<_GetClubsParams> get copyWith => __$GetClubsParamsCopyWithImpl<_GetClubsParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetClubsParams&&(identical(other.universityId, universityId) || other.universityId == universityId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,universityId,departmentId,type);

@override
String toString() {
  return 'GetClubsParams(universityId: $universityId, departmentId: $departmentId, type: $type)';
}


}

/// @nodoc
abstract mixin class _$GetClubsParamsCopyWith<$Res> implements $GetClubsParamsCopyWith<$Res> {
  factory _$GetClubsParamsCopyWith(_GetClubsParams value, $Res Function(_GetClubsParams) _then) = __$GetClubsParamsCopyWithImpl;
@override @useResult
$Res call({
 String universityId, String? departmentId, String type
});




}
/// @nodoc
class __$GetClubsParamsCopyWithImpl<$Res>
    implements _$GetClubsParamsCopyWith<$Res> {
  __$GetClubsParamsCopyWithImpl(this._self, this._then);

  final _GetClubsParams _self;
  final $Res Function(_GetClubsParams) _then;

/// Create a copy of GetClubsParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? universityId = null,Object? departmentId = freezed,Object? type = null,}) {
  return _then(_GetClubsParams(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,departmentId: freezed == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
