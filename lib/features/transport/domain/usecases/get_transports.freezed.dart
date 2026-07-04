// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_transports.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetTransportsParams {

 String get universityId;
/// Create a copy of GetTransportsParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetTransportsParamsCopyWith<GetTransportsParams> get copyWith => _$GetTransportsParamsCopyWithImpl<GetTransportsParams>(this as GetTransportsParams, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetTransportsParams&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,universityId);

@override
String toString() {
  return 'GetTransportsParams(universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class $GetTransportsParamsCopyWith<$Res>  {
  factory $GetTransportsParamsCopyWith(GetTransportsParams value, $Res Function(GetTransportsParams) _then) = _$GetTransportsParamsCopyWithImpl;
@useResult
$Res call({
 String universityId
});




}
/// @nodoc
class _$GetTransportsParamsCopyWithImpl<$Res>
    implements $GetTransportsParamsCopyWith<$Res> {
  _$GetTransportsParamsCopyWithImpl(this._self, this._then);

  final GetTransportsParams _self;
  final $Res Function(GetTransportsParams) _then;

/// Create a copy of GetTransportsParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? universityId = null,}) {
  return _then(_self.copyWith(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetTransportsParams].
extension GetTransportsParamsPatterns on GetTransportsParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetTransportsParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetTransportsParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetTransportsParams value)  $default,){
final _that = this;
switch (_that) {
case _GetTransportsParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetTransportsParams value)?  $default,){
final _that = this;
switch (_that) {
case _GetTransportsParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String universityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetTransportsParams() when $default != null:
return $default(_that.universityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String universityId)  $default,) {final _that = this;
switch (_that) {
case _GetTransportsParams():
return $default(_that.universityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String universityId)?  $default,) {final _that = this;
switch (_that) {
case _GetTransportsParams() when $default != null:
return $default(_that.universityId);case _:
  return null;

}
}

}

/// @nodoc


class _GetTransportsParams implements GetTransportsParams {
  const _GetTransportsParams({required this.universityId});
  

@override final  String universityId;

/// Create a copy of GetTransportsParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetTransportsParamsCopyWith<_GetTransportsParams> get copyWith => __$GetTransportsParamsCopyWithImpl<_GetTransportsParams>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetTransportsParams&&(identical(other.universityId, universityId) || other.universityId == universityId));
}


@override
int get hashCode => Object.hash(runtimeType,universityId);

@override
String toString() {
  return 'GetTransportsParams(universityId: $universityId)';
}


}

/// @nodoc
abstract mixin class _$GetTransportsParamsCopyWith<$Res> implements $GetTransportsParamsCopyWith<$Res> {
  factory _$GetTransportsParamsCopyWith(_GetTransportsParams value, $Res Function(_GetTransportsParams) _then) = __$GetTransportsParamsCopyWithImpl;
@override @useResult
$Res call({
 String universityId
});




}
/// @nodoc
class __$GetTransportsParamsCopyWithImpl<$Res>
    implements _$GetTransportsParamsCopyWith<$Res> {
  __$GetTransportsParamsCopyWithImpl(this._self, this._then);

  final _GetTransportsParams _self;
  final $Res Function(_GetTransportsParams) _then;

/// Create a copy of GetTransportsParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? universityId = null,}) {
  return _then(_GetTransportsParams(
universityId: null == universityId ? _self.universityId : universityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
